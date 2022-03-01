    
  const memoryUsage = new Chart(document.getElementById("memoryUsage"), {
    type: "line",
    data: {
        labels: ["Thu, 30 Dec", "Mon, 3 Jan", "Fri, 7 Jan", "Tue, 11 Jan", "Wed, 19 Jan", "Sun, 23 Jan", "Thu, 27th Jan" ],

        datasets: [
            {
              label: '',
              borderColor: "#18BDFB",
              data: [2.5,2.1,6.1,4.8,6.1,5.9,7.1,3.1,6.2,2.8,6.1,5.2,5,2,5.8],
              borderWidth: "2", 
              drawBorder: false,
              fill: true,
              backgroundColor: 'rgba(24, 189, 251, 0.1)',
              tension: 0.5,
              pointBorderWidth: 0,
              pointHitRadius: 0,
              pointHoverRadius: 14,
              pointHoverBackgroundColor: '#18BDFB',
              pointHoverBorderWidth: 2,
              pointHoverBorderColor: '#ffffff',
            },
        ],
    },
    options: {
      maintainAspectRatio: false,
      responsive: true,
      plugins: { legend: { display: false, }, tooltip: {bodyAlign: 'right',yAlign:'bottom',caretSize: 0, caretPadding: 20},},
        scales:
        {
            x: {
              ticks: {
                padding: 20
            },
              grid: {
                drawBorder: false,
                lineWidth: 0,
                tickColor: 'transparent',
                zeroLineColor: 'transparent',
              }
            },
            y: {
              ticks: {
                padding: 20,
                color: 'white'
            },
              grid: {
                borderDash: [5],
                drawBorder: false,
                tickColor: 'transparent',
                color: 'rgba(255,255,255,0.1)',
                zeroLineColor: 'transparent',
                drawBorder: false, // <-- this removes y-axis line
                lineWidth: 0.5,
              },
                  
            },
        },
    },
});
const totalVisitors = new Chart(document.getElementById("totalVisitors"), {
  type: "line",
  data: {
      labels: ["Thu, 30 Dec", "Mon, 3 Jan", "Fri, 7 Jan", "Tue, 11 Jan", "Wed, 19 Jan", "Sun, 23 Jan", "Thu, 27th Jan" ],

      datasets: [
          {
            label: '',
            borderColor: "#2C5FEA",
            data: [2.5,2.1,6.1,4.8,6.1,5.9,7.1,3.1,6.2,2.8,6.1,5.2,5,2,5.8],
            borderWidth: "2", 
            drawBorder: false,
            fill: true,
            backgroundColor: 'rgba(44, 95, 234, 0.1)',
            tension: 0.5,
            pointBorderWidth: 0,
            pointHitRadius: 25,
            pointHoverRadius: 10,
            pointBackgroundColor: 'transparent',
            pointHoverBackgroundColor: '#2C5FEA',
            pointHoverBorderWidth: 2,
            pointHoverBorderColor: '#ffffff',
          },
      ],
  },
  options: {
    maintainAspectRatio: false,
    responsive: true,
    plugins: { legend: { display: false, }, tooltip: {bodyAlign: 'right',yAlign:'bottom',caretSize: 0, caretPadding: 20},},
      scales:
      {
          x: {
            ticks: {
              padding: 20,
              
          },
            title: {display: false},
            grid: {
              drawBorder: false,
              lineWidth: 0,
              tickColor: 'transparent',
              zeroLineColor: 'transparent',
              title: {display: false},
            }
          },
          y: {
             ticks: {
              padding: 20,
              color: 'white'
          },
            grid: {
              borderDash: [5],
              drawBorder: false,
              tickColor: 'transparent',
              color: 'rgba(255,255,255,0.1)',
              zeroLineColor: 'transparent',
              drawBorder: false, // <-- this removes y-axis line
              lineWidth: 0.5,
              title: {display: false},
            },
                
          },
      },
  },
});

    google.charts.load('current', {
        'packages':['geochart'],
      });
      google.charts.setOnLoadCallback(drawRegionsMap);

      function drawRegionsMap() {
        var data = google.visualization.arrayToDataTable([
          ['Greenland', 'Popularity'],
          ['Greenland', 200],
          ['Brazil', 300],
          ['Russia', 500],
          ['United States', 100],

        ]);
        var options = {
          colorAxis: {colors: ['#284693', '#2B55C8', '#2C5FEA','#284693']},
          backgroundColor: 'transparent',
          datalessRegionColor: '#263C71',
          defaultColor: '#2C5FEA',
          legend: 'none',
        };

        var GeoChart = new google.visualization.GeoChart(document.getElementById('regions_div'));

        GeoChart.draw(data, options);
      }


    const myDoughnut = new Chart(document.getElementById("myDoughnut"), {
      type: "doughnut",
      options: {
      plugins: { legend: { display: false, }, },
      },
      data: {
        labels: [
          'Desktop',
          'Mobile',
          'Laptop',
          'Tablet'
        ],
        datasets: [{
          label: 'My First Dataset',
          data: [87.5, 8.8, 3.8,3.1],
          backgroundColor: [
            '#2C5FEA',
            '#18BDFB',
            '#B7FF79',
            '#10DAA4'
          ],
          borderColor: 'transparent',
          cutout: '80%',
        }],
      },
});