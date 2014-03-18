package mcs

class SchedulerJob {
    static triggers = {
//      simple repeatInterval: 500000l // execute job once in 5 seconds
        cron cronExpression: "0 0 /1 * * ?"
    }

    def execute() {
        // execute job
  //      println 'do some work every hour'  + new Date().format('dd.MM HH:mm:ss')
    }
}
