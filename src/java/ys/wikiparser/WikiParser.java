/*
 * Copyright (c) 2007 Yaroslav Stavnichiy, yarosla@gmail.com
 *
 * Latest version of this software can be obtained from:
 *   http://web-tec.info/WikiParser/
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.

 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 * If you make use of this code, I'd appreciate hearing about it.
 * Comments, suggestions, and bug reports welcome: yarosla@gmail.com
 */

package ys.wikiparser;

import static ys.wikiparser.Utils.*;

import java.net.*;

/**
 * WikiParser.renderXHTML() is the main method of this class.
 * It takes wiki-text and returns XHTML.
 *
 * WikiParser's behavior can be customized by overriding appendXxx() methods,
 * which should make integration of this class into any wiki/blog/forum software
 * easy and painless.
 *
 * @author Yaroslav Stavnichiy (yarosla@gmail.com)
 *
 */
public class WikiParser {

  private int wikiLength;
  private char wikiChars[];
  protected StringBuilder sb=new StringBuilder();
  private String wikiText;
  private int pos=0;
  private int listLevel=-1;
  private char listLevels[]=new char[6]; // max number of levels allowed
  private boolean blockquoteBR=false;
  private boolean inTable=false;

  private static enum ContextType {PARAGRAPH, LIST_ITEM, TABLE_CELL, HEADER, NOWIKI_BLOCK};

  private static final String[] ESCAPED_INLINE_SEQUENCES= {"{{{", "{{", "}}}", "**", "//", "__", "##", "\\\\", "[[", "<<<", "~", "--", "|"};

  private static final String LIST_CHARS="*-#>:";
  private static final String[] LIST_OPEN= {"<ul><li>", "<ul><li>", "<ol><li>", "<blockquote>", "<div class='indent'>"};
  private static final String[] LIST_CLOSE= {"</li></ul>\n", "</li></ul>\n", "</li></ol>\n", "</blockquote>\n", "</div>\n"};

  private static final String FORMAT_CHARS="*/_#";
  private static final String[] FORMAT_DELIM= {"**", "//", "__", "##"};
  private static final String[] FORMAT_TAG_OPEN= {"<strong>", "<em>", "<span class=\"underline\">", "<tt>"};
  private static final String[] FORMAT_TAG_CLOSE= {"</strong>", "</em>", "</span>", "</tt>"};


  public static String renderXHTML(String wikiText) {
    return new WikiParser(wikiText).toString();
  }

  protected WikiParser(String wikiText) {
    wikiText=preprocessWikiText(wikiText);

    this.wikiText=wikiText;
    wikiLength=this.wikiText.length();
    wikiChars=new char[wikiLength];
    this.wikiText.getChars(0, wikiLength, wikiChars, 0);

    while (parseBlock());

    closeListsAndTables();
  }

  public String toString() {
    return sb.toString();
  }

  private void closeListsAndTables() {
    // close unclosed lists
    while (listLevel>=0) {
      sb.append(LIST_CLOSE[LIST_CHARS.indexOf(listLevels[listLevel--])]);
    }
    if (inTable) {
      sb.append("</table>\n");
      inTable=false;
    }
  }

  private boolean parseBlock() {
    for (; pos<wikiLength && wikiChars[pos]<=' ' && wikiChars[pos]!='\n'; pos++) ; // skip whitespace
    if (pos>=wikiLength) return false;

    char c=wikiChars[pos];

    if (c=='\n') { // blank line => end of list/table; no other meaning
      closeListsAndTables();
      pos++;
      return true;
    }

    if (c=='|') { // table
      if (!inTable) {
        closeListsAndTables(); // close lists if any
        sb.append("<table border='1'>");
        inTable=true;
      }
      pos=parseTableRow(pos+1);
      return true;
    }
    else {
      if (inTable) {
        sb.append("</table>\n");
        inTable=false;
      }
    }

    if (listLevel>=0 || (c=='*' || c=='-' || c=='#' || c=='>' || c==':')) { // lists
      int lc;
      // count list level
      for (lc=0; lc<=listLevel && pos+lc<wikiLength && wikiChars[pos+lc]==listLevels[lc]; lc++) ;

      if (lc<=listLevel) { // end list block(s)
        do {
          sb.append(LIST_CLOSE[LIST_CHARS.indexOf(listLevels[listLevel--])]);
        } while (lc<=listLevel);
        // list(s) closed => retry from the same position
        return true;
      }
      else {
        if (pos+lc>=wikiLength) return false;
        char cc=wikiChars[pos+lc];
        int listType=LIST_CHARS.indexOf(cc);
        if (listType>=0 && pos+lc+1<wikiLength && wikiChars[pos+lc+1]!=cc) { // new list block
          sb.append(LIST_OPEN[listType]);
          listLevels[++listLevel]=cc;
          pos=parseListItem(pos+lc+1);
          return true;
        }
        else if (listLevel>=0) { // list item - same level
          if (listLevels[listLevel]=='>' || listLevels[listLevel]==':') sb.append('\n');
          else sb.append("</li>\n<li>");
          pos=parseListItem(pos+lc);
          return true;
        }
      }
    }

    if (c=='=') { // heading
      int hc;
      // count heading level
      for (hc=1; hc<6 && pos+hc<wikiLength && wikiChars[pos+hc]=='='; hc++) ;
      if (pos+hc>=wikiLength) return false;
      int p;
      for (p=pos+hc; p<wikiLength && (wikiChars[p]==' ' || wikiChars[p]=='\t'); p++) ; // skip spaces
      sb.append("<h"+hc+">");
      pos=parseItem(p, wikiText.substring(pos, pos+hc), ContextType.HEADER);
      sb.append("</h"+hc+">\n");
      return true;
    }
    else if (c=='{') { // nowiki-block?
      if (pos+3<wikiLength && wikiChars[pos+1]=='{' && wikiChars[pos+2]=='{') {
        int startNowiki=pos+3;
        int endNowiki=findEndOfNowiki(startNowiki);
        int endPos=endNowiki+3;
        if (wikiText.lastIndexOf('\n', endNowiki)>=startNowiki) { // block <pre>
          if (wikiChars[startNowiki]=='\n') startNowiki++; // skip the very first '\n'
          if (wikiChars[endNowiki-1]=='\n') endNowiki--; // omit the very last '\n'
          sb.append("<pre>");
          appendNowiki(wikiText.substring(startNowiki, endNowiki));
          sb.append("</pre>\n");
          pos=endPos;
          return true;
        }
        // else inline <nowiki> - proceed to regular paragraph handling
      }
    }
    else if (c=='-' && wikiText.startsWith("----", pos)) {
      int p;
      for (p=pos+4; p<wikiLength && (wikiChars[p]==' ' || wikiChars[p]=='\t'); p++) ; // skip spaces
      if (p==wikiLength || wikiChars[p]=='\n') {
        sb.append("\n<hr/>\n");
        pos=p;
        return true;
      }
    }
    else if (c=='~') { // block-level escaping: '*' '-' '#' '>' ':' '|' '='
      if (pos+1<wikiLength) {
        char nc=wikiChars[pos+1];
        if (nc=='>' || nc==':' || nc=='|' || nc=='=') { // can't be inline markup
          pos++; // skip '~' and proceed to regular paragraph handling
          c=nc;
        }
        else if (nc=='*' || nc=='-' || nc=='#') { // might be inline markup so need to double check
          char nnc=pos+2<wikiLength? wikiChars[pos+2]:0;
          if (nnc!=nc) {
            pos++; // skip '~' and proceed to regular paragraph handling
            c=nc;
          }
          // otherwise escaping will be done at line level
        }
      }
    }

    { // paragraph handling
      sb.append("<p>");
      pos=parseItem(pos, null, ContextType.PARAGRAPH);
      sb.append("</p>\n");
      return true;
    }
  }

  /**
   * Finds first closing '}}}' for nowiki block or span.
   * Skips escaped sequences: '~}}}'.
   *
   * @param startBlock points to first char after '{{{'
   * @return position of first '}' in closing '}}}'
   */
  private int findEndOfNowiki(int startBlock) {
    // NOTE: this method could step back one char from startBlock position
    int endBlock=startBlock-3;
    do {
      endBlock=wikiText.indexOf("}}}", endBlock+3);
      if (endBlock<0) return wikiLength; // no matching '}}}' found
      while (endBlock+3<wikiLength && wikiChars[endBlock+3]=='}')
        endBlock++; // shift to end of sequence of more than 3x'}' (eg. '}}}}}')
    } while (wikiChars[endBlock-1]=='~');
    return endBlock;
  }

  /**
   * Greedy version of findEndOfNowiki().
   * It finds the last possible closing '}}}' before next opening '{{{'.
   * Also uses escapes '~{{{' and '~}}}'.
   *
   * @param startBlock points to first char after '{{{'
   * @return position of first '}' in closing '}}}'
   */
  @SuppressWarnings("unused")
  private int findEndOfNowikiGreedy(int startBlock) {
    // NOTE: this method could step back one char from startBlock position
    int nextBlock=startBlock-3;
    do {
      do {
        nextBlock=wikiText.indexOf("{{{", nextBlock+3);
      } while (nextBlock>0 && wikiChars[nextBlock-1]=='~');
      if (nextBlock<0) nextBlock=wikiLength;
      int endBlock=wikiText.lastIndexOf("}}}", nextBlock);
      if (endBlock>=startBlock && wikiChars[endBlock-1]!='~') return endBlock;
    } while (nextBlock<wikiLength);
    return wikiLength;
  }

  /**
   * @param start points to first char after pipe '|'
   * @return
   */
  private int parseTableRow(int start) {
    if (start>=wikiLength) return wikiLength;

    sb.append("<tr>");
    boolean endOfRow=false;
    do {
      int colspan=0;
      while (start+colspan<wikiLength && wikiChars[start+colspan]=='|') colspan++;
      start+=colspan;
      colspan++;
      boolean th=start<wikiLength && wikiChars[start]=='=';
      start+=(th?1:0);
      while (start<wikiLength && wikiChars[start]<=' ' && wikiChars[start]!='\n') start++; // trim whitespace from the start

      if (start>=wikiLength || wikiChars[start]=='\n') { // skip last empty column
        start++; // eat '\n'
        break;
      }

      sb.append(th? "<th":"<td");
      if (colspan>1) sb.append(" colspan=\""+colspan+"\"");
      sb.append('>');
      try {
        parseItemThrow(start, null, ContextType.TABLE_CELL);
      }
      catch (EndOfSubContextException e) { // end of cell
        start=e.position;
        if (start>=wikiLength) endOfRow=true;
        else if (wikiChars[start]=='\n') {
          start++; // eat '\n'
          endOfRow=true;
        }
      }
      catch (EndOfContextException e) {
        start=e.position;
        endOfRow=true;
      }
      sb.append(th? "</th>":"</td>");
    } while (!endOfRow/* && start<wikiLength && wikiChars[start]!='\n'*/);
    sb.append("</tr>\n");
    return start;
  }

  /**
   * Same as parseItem(); blank line adds &lt;br/&gt;&lt;br/&gt;
   *
   * @param start
   */
  private int parseListItem(int start) {
    while (start<wikiLength && wikiChars[start]<=' ' && wikiChars[start]!='\n') start++; // skip spaces
    int end=parseItem(start, null, ContextType.LIST_ITEM);
    if ((listLevels[listLevel]=='>' || listLevels[listLevel]==':') && wikiText.substring(start, end).trim().length()==0) { // empty line within blockquote/div
      if (!blockquoteBR) {
        sb.append("<br/><br/>");
        blockquoteBR=true;
      }
    }
    else {
      blockquoteBR=false;
    }
    return end;
  }

  /**
   * @param p points to first slash in suspected URI (scheme://etc)
   * @param start points to beginning of parsed item
   * @param start points to end of parsed item
   *
   * @return array of two integer offsets [begin_uri, end_uri] if matched, null otherwise
   */
  private int[] checkURI(int p, int start, int end) {
    if (p>start && wikiChars[p-1]==':') { // "://" found
      int pb=p-1;
      while (pb>start && isLatinLetterOrDigit(wikiChars[pb-1])) pb--;
      int pe=p+2;
      while (pe<end && isUrlChar(wikiChars[pe])) pe++;
      URI uri=null;
      do {
        while (pe>p+2 && ",.%;".indexOf(wikiChars[pe-1])>=0) pe--; // don't want these chars at the end of URI
        try { // verify URL syntax
          uri=new URI(wikiText.substring(pb, pe));
        }
        catch (URISyntaxException e) {
          pe--; // try choping from the end
        }
      } while (uri==null && pe>p+2);
      if (uri!=null && uri.isAbsolute()) {
        int offs[]= {pb, pe};
        return offs;
      }
    }
    return null;
  }

  private int parseItem(int start, String delimiter, ContextType context) {
    try {
      return parseItemThrow(start, delimiter, context);
    }
    catch (EndOfContextException e) {
      return e.position;
    }
  }

  private int parseItemThrow(int start, String delimiter, ContextType context) throws EndOfContextException {
    StringBuilder tb=new StringBuilder();

    boolean specialCaseDelimiterHandling="//".equals(delimiter);
    int p=start;
    int end=wikiLength;

    try {
      nextChar: while(true) {
        if (p>=end) throw new EndOfContextException(end); //break;

        if (delimiter!=null && wikiText.startsWith(delimiter, p)) {
          if (!specialCaseDelimiterHandling || checkURI(p, start, end)==null) {
            p+=delimiter.length();
            return p;
          }
        }

        char c=wikiChars[p];

        // context-defined break test
        if (c=='\n') {
          if (context==ContextType.HEADER || context==ContextType.TABLE_CELL) {
            p++;
            throw new EndOfContextException(p);
          }
          if (p+1<end && wikiChars[p+1]=='\n') { // blank line delimits everything
            p++; // leave one '\n' unparsed so parseBlock() can close all lists
            throw new EndOfContextException(p);
          }
          for (p++; p<end && wikiChars[p]<=' ' && wikiChars[p]!='\n'; p++) ; // skip whitespace
          if (p>=end) throw new EndOfContextException(p);

          c=wikiChars[p];

          if (LIST_CHARS.indexOf(c)>=0) { // lists
            if (context==ContextType.LIST_ITEM) throw new EndOfContextException(p);
            if (p+1<end && wikiChars[p+1]!=c) throw new EndOfContextException(p);
            // also check for ---- <hr>
            if (wikiText.startsWith("----", p)) {
              int pp;
              for (pp=p+4; pp<end && (wikiChars[pp]==' ' || wikiChars[pp]=='\t'); pp++) ; // skip spaces
              if (pp==end || wikiChars[pp]=='\n') throw new EndOfContextException(p); // yes, it's <hr>
            }
          }
          else if (c=='=') { // header
            throw new EndOfContextException(p);
          }
          else if (c=='|') { // table
            throw new EndOfContextException(p);
          }

          // if none matched add '\n' to text buffer
          tb.append('\n');
          // p and c already shifted past the '\n' and whitespace after, so go on
        }
        else if (c=='|') {
          if (context==ContextType.TABLE_CELL) {
            p++;
            throw new EndOfSubContextException(p);
          }
        }

        int formatType;

        if (c=='{') {
          if (p+1<end && wikiChars[p+1]=='{') {
            if (p+2<end && wikiChars[p+2]=='{') { // inline or block <nowiki>
              appendText(tb.toString()); tb.delete(0, tb.length()); // flush text buffer
              int startNowiki=p+3;
              int endNowiki=findEndOfNowiki(startNowiki);
              p=endNowiki+3;
              if (wikiText.lastIndexOf('\n', endNowiki)>=startNowiki) { // block <pre>
                if (wikiChars[startNowiki]=='\n') startNowiki++; // skip the very first '\n'
                if (wikiChars[endNowiki-1]=='\n') endNowiki--; // omit the very last '\n'
                sb.append("<pre>");
                appendNowiki(wikiText.substring(startNowiki, endNowiki));
                sb.append("</pre>\n");
                //if (context==ContextType.NOWIKI_BLOCK) return p; // in this context return immediately after nowiki
              }
              else { // inline <nowiki>
                appendNowiki(wikiText.substring(startNowiki, endNowiki));
              }
              continue;
            }
            else if (p+2<end) { // {{image}}
              int endImg=wikiText.indexOf("}}", p+2);
              if (endImg>=0 && endImg<end) {
                appendText(tb.toString()); tb.delete(0, tb.length()); // flush text buffer
                appendImage(wikiText.substring(p+2, endImg));
                p=endImg+2;
                continue;
              }
            }
          }
        }
        else if (c=='[') {
          if (p+1<end && wikiChars[p+1]=='[') { // [[link]]
            int endLink=wikiText.indexOf("]]", p+2);
            if (endLink>=0 && endLink<end) {
              appendText(tb.toString()); tb.delete(0, tb.length()); // flush text buffer
              appendLink(wikiText.substring(p+2, endLink));
              p=endLink+2;
              continue;
            }
          }
        }
        else if (c=='\\') {
          if (p+1<end && wikiChars[p+1]=='\\') { // \\ = <br/>
            appendText(tb.toString()); tb.delete(0, tb.length()); // flush text buffer
            sb.append("<br/>");
            p+=2;
            continue;
          }
        }
        else if (c=='<') {
          if (p+1<end && wikiChars[p+1]=='<') {
            if (p+2<end && wikiChars[p+2]=='<') { // <<<macro>>>
              int endMacro=wikiText.indexOf(">>>", p+3);
              if (endMacro>=0 && endMacro<end) {
                appendText(tb.toString()); tb.delete(0, tb.length()); // flush text buffer
                appendMacro(wikiText.substring(p+3, endMacro));
                p=endMacro+3;
                continue;
              }
            }
          }
        }
        else if ((formatType=FORMAT_CHARS.indexOf(c))>=0) {
          if (p+1<end && wikiChars[p+1]==c) {
            appendText(tb.toString()); tb.delete(0, tb.length()); // flush text buffer
            if (c=='/') { // special case for "//" - check if it is part of URL (scheme://etc)
              int[] uriOffs=checkURI(p, start, end);
              if (uriOffs!=null) {
                int pb=uriOffs[0], pe=uriOffs[1];
                if (pb>start && wikiChars[pb-1]=='~') {
                  sb.delete(sb.length()-(p-pb+1), sb.length()); // roll back URL + tilde
                  sb.append(escapeHTML(wikiText.substring(pb, pe)));
                }
                else {
                  sb.delete(sb.length()-(p-pb), sb.length()); // roll back URL
                  appendLink(wikiText.substring(pb, pe));
                }
                p=pe;
                continue;
              }
            }
            sb.append(FORMAT_TAG_OPEN[formatType]);
            try {
              p=parseItemThrow(p+2, FORMAT_DELIM[formatType], context);
            }
            finally {
              sb.append(FORMAT_TAG_CLOSE[formatType]);
            }
            continue;
          }
        }
        else if (c=='~') { // escape
          // start line escapes are dealt with in parseBlock()
          for (String e: ESCAPED_INLINE_SEQUENCES) {
            if (wikiText.startsWith(e, p+1)) {
              appendText(tb.toString()); tb.delete(0, tb.length()); // flush text buffer
              sb.append(e);
              p+=1+e.length();
              continue nextChar;
            }
          }
        }
        else if (c=='-') { // ' -- ' => &ndash;
          if (p+2<end && wikiChars[p+1]=='-' && wikiChars[p+2]==' ' && p>start && wikiChars[p-1]==' ') {
            appendText(tb.toString()); tb.delete(0, tb.length()); // flush text buffer
            sb.append("&ndash; ");
            p+=3;
            continue;
          }
        }
        tb.append(c);
        p++;
      }
    }
    finally {
      appendText(tb.toString()); tb.delete(0, tb.length()); // flush text buffer
    }
  }


  protected void appendMacro(String text) {
    sb.append("&lt;&lt;&lt;Macro:");
    sb.append(escapeHTML(unescapeHTML(text)));
    sb.append("&gt;&gt;&gt;");
  }

  protected void appendLink(String text) {
    String[] link=split(text, '|');
    URI uri=null;
    try { // validate URI
      uri=new URI(link[0].trim());
    }
    catch (URISyntaxException e) {
    }
    if (uri!=null && uri.isAbsolute()) {
      sb.append("<a href=\""+escapeHTML(uri.toString())+"\" rel=\"nofollow\">");
      sb.append(escapeHTML(unescapeHTML(link.length>=2 && !isEmpty(link[1].trim())? link[1]:link[0])));
      sb.append("</a>");
    }
    else {
      sb.append("<a href=\"#\" title=\"Internal link\">");
      sb.append(escapeHTML(unescapeHTML(link.length>=2 && !isEmpty(link[1].trim())? link[1]:link[0])));
      sb.append("</a>");
    }
  }

  protected void appendImage(String text) {
    String[] link=split(text, '|');
    URI uri=null;
    try { // validate URI
      uri=new URI(link[0].trim());
    }
    catch (URISyntaxException e) {
    }
    if (uri!=null && uri.isAbsolute()) {
      String alt=escapeHTML(unescapeHTML(link.length>=2 && !isEmpty(link[1].trim())? link[1]:link[0]));
      sb.append("<img src=\""+escapeHTML(uri.toString())+"\" alt=\""+alt+"\" title=\""+alt+"\" />");
    }
    else {
      sb.append("&lt;&lt;&lt;Internal image(?): ");
      sb.append(escapeHTML(unescapeHTML(text)));
      sb.append("&gt;&gt;&gt;");
    }
  }

  protected void appendText(String text) {
    sb.append(escapeHTML(unescapeHTML(text)));
  }

  protected void appendNowiki(String text) {
    sb.append(escapeHTML(replaceString(replaceString(text, "~{{{", "{{{"), "~}}}", "}}}")));
  }

  private static class EndOfContextException extends Exception {
    private static final long serialVersionUID=1L;
    int position;
    public EndOfContextException(int position) {
      super();
      this.position=position;
    }
  }

  private static class EndOfSubContextException extends EndOfContextException {
    private static final long serialVersionUID=1L;
    public EndOfSubContextException(int position) {
      super(position);
    }
  }
}
