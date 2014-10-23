var hits=[];
var label=[];
var price_min=[];
var price_max=[];
var price_avg=[];
jQuery(document).ready(function() {


var graphData = function() {

  return [
    {
      values: price_min.reverse(),
      key: 'MIN'
    },
    
    {
       values: price_max.reverse(),
      key: 'MAX'
    },
    {
       values: price_avg.reverse(),
      key: 'AVG'
    }
  ];
};

var popularityData = function() {
  return [
    {
      values: hits,
      key: 'Hits',
      color: '#ff7f0e'
    }
  ];
};
//popul
nv.addGraph(function() {
    var chart = nv.models.multiBarChart();
    chart.reduceXTicks(false);
	chart.margin({left:30, bottom:75});
   // chart.xAxis
    //    .tickFormat(d3.format(',f'));
    chart.showControls(false);
    chart.yAxis
        .tickFormat(d3.format(',f'));
    chart.xAxis.rotateLabels(-45);
    d3.select('#popularitychart svg')
        .datum(popularityData())
        .transition().duration(500)
        .call(chart)
        ;

    nv.utils.windowResize(chart.update);

    return chart;
});
//price
 nv.addGraph(function() {
  var chart = nv.models.lineChart();
  chart.useInteractiveGuideline(true);
    chart.yAxis.tickFormat(d3.format(',.2f'));
    chart.xAxis.rotateLabels(-45);
chart.margin({left:60, bottom:75, right: 35});
    var x_format = function(num) {
        return label[num];
    };

    chart.xAxis
        .orient("bottom")
        .tickFormat(x_format);

  d3.select('#pricechart svg')
    .datum(graphData())
    .transition().duration(500)
    .call(chart)
    ;

  nv.utils.windowResize(chart.update);

  return chart;
});

});

