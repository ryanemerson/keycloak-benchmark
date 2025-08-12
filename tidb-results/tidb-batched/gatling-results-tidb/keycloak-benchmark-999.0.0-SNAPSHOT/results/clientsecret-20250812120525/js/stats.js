var stats = {
    type: "GROUP",
name: "All Requests",
path: "",
pathFormatted: "group_missing-name--1146707516",
stats: {
    "name": "All Requests",
    "numberOfRequests": {
        "total": "457500",
        "ok": "457500",
        "ko": "0"
    },
    "minResponseTime": {
        "total": "9",
        "ok": "9",
        "ko": "-"
    },
    "maxResponseTime": {
        "total": "1093",
        "ok": "1093",
        "ko": "-"
    },
    "meanResponseTime": {
        "total": "46",
        "ok": "46",
        "ko": "-"
    },
    "standardDeviation": {
        "total": "20",
        "ok": "20",
        "ko": "-"
    },
    "percentiles1": {
        "total": "48",
        "ok": "48",
        "ko": "-"
    },
    "percentiles2": {
        "total": "56",
        "ok": "56",
        "ko": "-"
    },
    "percentiles3": {
        "total": "65",
        "ok": "65",
        "ko": "-"
    },
    "percentiles4": {
        "total": "76",
        "ok": "76",
        "ko": "-"
    },
    "group1": {
    "name": "t < 800 ms",
    "htmlName": "t < 800 ms",
    "count": 457480,
    "percentage": 99.99562841530054
},
    "group2": {
    "name": "800 ms <= t < 1200 ms",
    "htmlName": "t >= 800 ms <br> t < 1200 ms",
    "count": 20,
    "percentage": 0.004371584699453552
},
    "group3": {
    "name": "t >= 1200 ms",
    "htmlName": "t >= 1200 ms",
    "count": 0,
    "percentage": 0.0
},
    "group4": {
    "name": "failed",
    "htmlName": "failed",
    "count": 0,
    "percentage": 0.0
},
    "meanNumberOfRequestsPerSecond": {
        "total": "736.71",
        "ok": "736.71",
        "ko": "-"
    }
},
contents: {
"req_client-credenti-8544055": {
        type: "REQUEST",
        name: "Client credentials grant type",
path: "Client credentials grant type",
pathFormatted: "req_client-credenti-8544055",
stats: {
    "name": "Client credentials grant type",
    "numberOfRequests": {
        "total": "457500",
        "ok": "457500",
        "ko": "0"
    },
    "minResponseTime": {
        "total": "9",
        "ok": "9",
        "ko": "-"
    },
    "maxResponseTime": {
        "total": "1093",
        "ok": "1093",
        "ko": "-"
    },
    "meanResponseTime": {
        "total": "46",
        "ok": "46",
        "ko": "-"
    },
    "standardDeviation": {
        "total": "20",
        "ok": "20",
        "ko": "-"
    },
    "percentiles1": {
        "total": "48",
        "ok": "48",
        "ko": "-"
    },
    "percentiles2": {
        "total": "56",
        "ok": "56",
        "ko": "-"
    },
    "percentiles3": {
        "total": "65",
        "ok": "65",
        "ko": "-"
    },
    "percentiles4": {
        "total": "76",
        "ok": "76",
        "ko": "-"
    },
    "group1": {
    "name": "t < 800 ms",
    "htmlName": "t < 800 ms",
    "count": 457480,
    "percentage": 99.99562841530054
},
    "group2": {
    "name": "800 ms <= t < 1200 ms",
    "htmlName": "t >= 800 ms <br> t < 1200 ms",
    "count": 20,
    "percentage": 0.004371584699453552
},
    "group3": {
    "name": "t >= 1200 ms",
    "htmlName": "t >= 1200 ms",
    "count": 0,
    "percentage": 0.0
},
    "group4": {
    "name": "failed",
    "htmlName": "failed",
    "count": 0,
    "percentage": 0.0
},
    "meanNumberOfRequestsPerSecond": {
        "total": "736.71",
        "ok": "736.71",
        "ko": "-"
    }
}
    }
}

}

function fillStats(stat){
    $("#numberOfRequests").append(stat.numberOfRequests.total);
    $("#numberOfRequestsOK").append(stat.numberOfRequests.ok);
    $("#numberOfRequestsKO").append(stat.numberOfRequests.ko);

    $("#minResponseTime").append(stat.minResponseTime.total);
    $("#minResponseTimeOK").append(stat.minResponseTime.ok);
    $("#minResponseTimeKO").append(stat.minResponseTime.ko);

    $("#maxResponseTime").append(stat.maxResponseTime.total);
    $("#maxResponseTimeOK").append(stat.maxResponseTime.ok);
    $("#maxResponseTimeKO").append(stat.maxResponseTime.ko);

    $("#meanResponseTime").append(stat.meanResponseTime.total);
    $("#meanResponseTimeOK").append(stat.meanResponseTime.ok);
    $("#meanResponseTimeKO").append(stat.meanResponseTime.ko);

    $("#standardDeviation").append(stat.standardDeviation.total);
    $("#standardDeviationOK").append(stat.standardDeviation.ok);
    $("#standardDeviationKO").append(stat.standardDeviation.ko);

    $("#percentiles1").append(stat.percentiles1.total);
    $("#percentiles1OK").append(stat.percentiles1.ok);
    $("#percentiles1KO").append(stat.percentiles1.ko);

    $("#percentiles2").append(stat.percentiles2.total);
    $("#percentiles2OK").append(stat.percentiles2.ok);
    $("#percentiles2KO").append(stat.percentiles2.ko);

    $("#percentiles3").append(stat.percentiles3.total);
    $("#percentiles3OK").append(stat.percentiles3.ok);
    $("#percentiles3KO").append(stat.percentiles3.ko);

    $("#percentiles4").append(stat.percentiles4.total);
    $("#percentiles4OK").append(stat.percentiles4.ok);
    $("#percentiles4KO").append(stat.percentiles4.ko);

    $("#meanNumberOfRequestsPerSecond").append(stat.meanNumberOfRequestsPerSecond.total);
    $("#meanNumberOfRequestsPerSecondOK").append(stat.meanNumberOfRequestsPerSecond.ok);
    $("#meanNumberOfRequestsPerSecondKO").append(stat.meanNumberOfRequestsPerSecond.ko);
}
