function createSeries(chart, axis, field, name) {
    // Create series
    var series = chart.series.push(new am4charts.LineSeries());
    series.dataFields.dateX = "Date";
    series.dataFields.valueY = field;
    //series.dataFields.categoryX = "Date";
    series.strokeWidth = 2;
    series.xAxis = axis;
    series.name = name;
    series.tooltipText = "{name}: [bold]{valueY}[/]";
    //series.fillOpacity = 0.8;

    // For curvey lines
    series.tensionX = 0.8;
    series.tensionY = 1;

    // Multiple bullet options - circle, triangle, rectangle etc.
    var bullet = series.bullets.push(new am4charts.CircleBullet());
    bullet.fill = new am4core.InterfaceColorSet().getFor("background");
    bullet.fillOpacity = 1;
    bullet.strokeWidth = 2;
    bullet.circle.radius = 4;

    return series;
}

function createMultiLineChart(chartData) {
    // Themes begin
    am4core.useTheme(am4themes_animated);

    var chart = am4core.create("chartdiv", am4charts.XYChart);

    // Increase contrast by taking evey second color
    chart.colors.step = 3;
    //chart.hiddenState.properties.opacity = 0; // this creates initial fade-in

    // Add title to chart
    var title = chart.titles.create();
    title.text = chartData["title"];
    title.fontSize = 25;
    title.marginBottom = 15;

    chart.data = chartData["data"];

    // Create axes - for normal Axis
    // var categoryAxis = chart.xAxes.push(new am4charts.CategoryAxis());
    // categoryAxis.dataFields.category = "Date";
    // categoryAxis.renderer.grid.template.location = 0;

    // Create axes - for Date Axis
    var dateAxis = chart.xAxes.push(new am4charts.DateAxis());
    //dateAxis.dataFields.category = "Date";
    dateAxis.renderer.grid.template.location = 0;
    dateAxis.renderer.minGridDistance = 50;
    dateAxis.title.text = chartData["label"]["domainAxis"];

    var valueAxis = chart.yAxes.push(new am4charts.ValueAxis());
    //valueAxis.renderer.line.strokeOpacity = 1;
    //valueAxis.renderer.line.strokeWidth = 2;
    valueAxis.title.text = chartData["label"]["rangeAxis"];

    //var single_data_item = chartData["data"][0];
    var series1 = createSeries(chart, dateAxis, "Toyota", "Toyota");
    var series2 = createSeries(chart, dateAxis, "Ford", "Ford");
    var series3 = createSeries(chart, dateAxis, "Honda", "Honda");
    var series4 = createSeries(chart, dateAxis, "Renault", "Renault");

    // Add legend
    chart.legend = new am4charts.Legend();

    // Add cursor
    chart.cursor = new am4charts.XYCursor();
    chart.cursor.xAxis = dateAxis;

    // Add scrollbar
    chart.scrollbarX = new am4core.Scrollbar();

    // Add export menu
    chart.exporting.menu = new am4core.ExportMenu();
}
