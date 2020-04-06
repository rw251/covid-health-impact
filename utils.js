const { readdirSync, readFileSync, writeFileSync, createWriteStream } = require('fs');
const { join } = require('path');
// const Chart = require('chart.js');
// const { createCanvas } = require('canvas')

let output;
let ageMarkers = [5]; // e.g. [5,15,39] would give 0-4, 5-14, 15-38, 39+

// const resetOutput = () => {
//   output = {
//     yearCounts: {},
//     weekCounts: {},
//   };
// }

const getStartOfWeek = (dateString) => {
  const date = new Date(dateString);
  date.setDate(date.getDate() + 1 - (date.getDay() || 7));
  return date;
}

// const processDataFile = (filename) => {
//   const symptom = filename.replace('covid-symptoms-', '').split('.')[0];
//   output.yearCounts[symptom] = {};
//   output.weekCounts[symptom] = {};
//   readFileSync(join('data-extraction', 'data', filename), 'utf8')
//     .split('\n')
//     .slice(1)
//     .forEach(line => {
//       const [dateString, count] = line.trim().replace('/\r/g','').split(',');
//       if(!dateString) return;
//       const date = new Date(dateString);
//       const year = date.getFullYear();
//       const startOfWeek = getStartOfWeek(dateString);
//       let startOfWeekYear = startOfWeek.getFullYear();
//       if(startOfWeekYear === 1999) return;
//       if(!output.weekCounts[symptom][startOfWeekYear]) {
//         output.weekCounts[symptom][startOfWeekYear] = {};
//       }
//       if(!output.weekCounts[symptom][startOfWeekYear][startOfWeek.getTime()]) {
//         output.weekCounts[symptom][startOfWeekYear][startOfWeek.getTime()] = 0;
//       }
//       output.weekCounts[symptom][startOfWeekYear][startOfWeek.getTime()] += +count;
//       if(date.getMonth()<7) return;
//       if(!output.yearCounts[symptom][year]) output.yearCounts[symptom][year] = 0;
//       output.yearCounts[symptom][year] += +count;
//     });
// }

// exports.processRawDataFiles = (directory = './data-extraction/data') => {
//   resetOutput();
//   readdirSync(directory)
//     .filter(x => x.indexOf('.txt') > -1)
//     .forEach(file => processDataFile(file));
//   return output;
// }

const codesFromFile = (pathToFile) => readFileSync(pathToFile, 'utf8')
  .split('\n')
  .map(x => x.split('\t')[0]);

const codesWithoutTermCode = (codes) => {
  const codesWithoutTermExtension = codes
    .filter(x => x.length===7 && x[5] === '0' && x[6] === '0')
    .map(x => x.substr(0,5));
  return codes.concat(codesWithoutTermExtension);
}

// const createHighTemperatureQuery = () => {
//   const template = readFileSync(join(__dirname, 'data-extraction', 'sql-queries', 'template-high-temperature.sql'), 'utf8');
//   const highTempCodes = codesFromFile(join(__dirname, 'data-extraction', 'codesets', 'covid-symptom-high-temperature.txt'), 'utf8');
//   const allHighTempCodes = codesWithoutTermCode(highTempCodes);
//   const tempCodes = codesFromFile(join(__dirname, 'data-extraction', 'codesets', 'covid-symptom-temperature.txt'), 'utf8');
//   const allTempCodes = codesWithoutTermCode(tempCodes);
//   let query = template.replace(/\{\{HIGH_TEMPERATURE_CODES\}\}/g, allHighTempCodes.join("','"));
//   query = query.replace(/\{\{TEMPERATURE_CODES\}\}/g, allTempCodes.join("','"));
//   const ageQueryBase = query.slice(0);
//   query = query.replace(/\{\{!AGE\}\}[\s\S]*\{\{AGE\}\}/,"");
//   query = query.replace(/\{\{.?MAIN\}\}/g,"");
//   writeFileSync(join(__dirname, 'data-extraction', 'sql-queries', `covid-symptoms-high-temperature.sql`), query);
//   // age queries
//   let lowerAge = 0;
//   ageMarkers.forEach(ageMarker => {
//     let ageBase = ageQueryBase.replace(/\{\{!MAIN\}\}[\s\S]*\{\{MAIN\}\}/,"");
//     ageBase = ageBase.replace(/\{\{.?AGE\}\}/g,"");
//     ageBase = ageBase.replace(/\{\{LOWER_AGE\}\}/g, lowerAge);
//     ageBase = ageBase.replace(/\{\{UPPER_AGE\}\}/g, ageMarker);
//     writeFileSync(join(__dirname, 'data-extraction', 'sql-queries', `covid-symptoms-high-temperature-age-${lowerAge}-${ageMarker}.sql`), ageBase);
//     lowerAge = ageMarker;
//   });
//   let ageBase = ageQueryBase.replace(/\{\{!MAIN\}\}[\s\S]*\{\{MAIN\}\}/,"");
//   ageBase = ageBase.replace(/\{\{.?AGE\}\}/g,"");
//   ageBase = ageBase.replace(/\{\{LOWER_AGE\}\}/g, lowerAge);
//   ageBase = ageBase.replace(/\{\{UPPER_AGE\}\}/g, 120);
//   writeFileSync(join(__dirname, 'data-extraction', 'sql-queries', `covid-symptoms-high-temperature-age-${lowerAge}-.sql`), ageBase);
// }

exports.createSqlQueries = () => {
  const template = readFileSync(join(__dirname, 'data-extraction', 'sql-queries', 'template-standard.sql'), 'utf8');
  readdirSync(join(__dirname, 'data-extraction', 'codesets'))
    .filter(x => {
      if(x.indexOf('.json') > -1) return false; // don't want the metadata
      return true;
    })
    .map(filename => {
      const symptomDashed = filename.split('.')[0];
      const symptomCapitalCase = symptomDashed.split('-').map(x => x[0].toUpperCase() + x.slice(1)).join('');
      const symptomLowerSpaced = symptomDashed.split('-').map(x => x.toLowerCase()).join(' ');
      const codes = codesFromFile(join(__dirname, 'data-extraction', 'codesets', filename));
      const allCodes = codesWithoutTermCode(codes);
      const codeString = allCodes.join("','");
      let query = template.replace(/\{\{SYMPTOM_LOWER_SPACED\}\}/g, symptomLowerSpaced);
      query = query.replace(/\{\{SYMPTOM_CAPITAL_NO_SPACE\}\}/g, symptomCapitalCase);
      query = query.replace(/\{\{SYMPTOM_DASHED\}\}/g, symptomDashed);
      query = query.replace(/\{\{CLINICAL_CODES\}\}/g, codeString);
      query = query.replace(/\{\{!AGE\}\}[\s\S]*\{\{AGE\}\}/,"");
      query = query.replace(/\{\{.?MAIN\}\}/g,"");
      writeFileSync(join(__dirname, 'data-extraction', 'sql-queries', `covid-symptoms-${symptomDashed}.sql`), query);
    });
};

// exports.getTableOfResults = (processedData, fieldSeparator = '\t', rowSeparator = '\n') => {
//   const header = ['Symptom'];
//   for(var i = 2000; i < 2020; i++) {
//     header.push(i);
//   }
//   const tableRows = [header.join(fieldSeparator)];
//   Object.keys(processedData).forEach(key => {
//     const row = [key];
//     for(var i = 2000; i < 2020; i++) {
//       row.push(processedData[key][i]);
//     }
//     tableRows.push(row.join(fieldSeparator));
//   });
//   return tableRows.join(rowSeparator);
// }

// const createLineChart = (label, rawData) => new Promise((resolve) => {
//   const canvas = createCanvas(2000, 1000);
//   const ctx = canvas.getContext('2d');

//   const colours = [
//     'rgb(241, 196, 15)',
//     'rgb(39, 174, 96)',
//     'rgb(26, 188, 156)',
//     'rgb(41, 128, 185)',
//     'rgb(155, 89, 182)',
//     'rgb(192, 57, 43)',
//     'rgb(52, 73, 94)',
//   ];
  
//   const labels = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52];
//   const datasets = Object.keys(rawData).filter(x => +x > 2013).sort().map((year, idx) => {
//     return {
//       label: year,
//       data: Object.keys(rawData[year]).filter(x => +x > 2013).sort().map(date => rawData[year][date]),
//       fill:false,
//       borderColor: colours[idx],
//       borderWidth: year >= 2019 ? 5 : 3,
//       lineTension: 0,
//       pointRadius: 0,
//     };
//   });
 
//   Chart.defaults.global.defaultFontColor = 'black';
//   Chart.defaults.global.defaultFontSize = 24;
//   Chart.defaults.global.defaultFontStyle = '600';
//   var myChart = new Chart(ctx, {
//     type: 'line',
//     data: {
//       labels,
//       datasets,
//     },
//     options: {
//       title: {
//         display: true,
//         text: `Weekly number of patients reporting the symptom "${label}" one line per year`,
//       },
//       responsive:false,
//       animation:false,
//       width:2000,
//       height:1000,
//       scales: {
//         yAxes: [{
//             ticks: {
//                 beginAtZero: true
//             },
//             gridLines: {
//               color: "rgb(30,30,30)",
//               zeroLineColor: "rgb(30,30,30)",
//               lineWidth: 2,
//             }
//         }],
//         xAxes: [{
//           gridLines: {
//             lineWidth: 0,
//           }
//         }]
//       },
//     }
//   });
   
//   const out = createWriteStream(join(__dirname, 'images', `weekly-analysis-${label}.png`));
//   const stream = canvas.createPNGStream();
//   stream.pipe(out);
//   out.on('finish', resolve);
// });

// const createBarChart = (label, rawData) => new Promise((resolve) => {
//   const canvas = createCanvas(1600, 900);
//   const ctx = canvas.getContext('2d');
  
//   const labels = Object.keys(rawData).sort();
//   const data = Object.keys(rawData).sort().map(year => rawData[year]);
 
//   Chart.defaults.global.defaultFontColor = 'black';
//   Chart.defaults.global.defaultFontSize = 24;
//   Chart.defaults.global.defaultFontStyle = '600';
//   var myChart = new Chart(ctx, {
//     type: 'bar',
//     data: {
//         labels,
//         datasets: [{
//             label,
//             data,
//             fill: false,
//             backgroundColor: "rgb(91, 155, 213)",
//             barPercentage: 0.6,
//             lineTension: 0.1
//         }]
//     },
//     options: {
//       title: {
//         display: true,
//         text: `Total number of patients reporting the symptom "${label}" in the period 1st August - 31st December every year`,
//       },
//       legend: {
//         display: false,
//       },
//       responsive:false,
//       animation:false,
//       width:1024,
//       height:768,
//       scales: {
//         yAxes: [{
//             ticks: {
//                 beginAtZero: true
//             },
//             gridLines: {
//               color: "rgb(30,30,30)",
//               zeroLineColor: "rgb(30,30,30)",
//               lineWidth: 1.7,
//             }
//         }],
//         xAxes: [{
//           gridLines: {
//             lineWidth: 0,
//           }
//         }]
//       },
//     }
//   });
   
//   const out = createWriteStream(join(__dirname, 'images', `all-years-${label}.png`));
//   const stream = canvas.createPNGStream();
//   stream.pipe(out);
//   out.on('finish', resolve);
// });

// exports.drawIndividualBarCharts = (processedData) => Promise.all(
//   Object
//     .keys(processedData)
//     .map(label => createBarChart(label, processedData[label]))
// );

// exports.drawIndividualLineCharts = (rawData) => Promise.all(
//   Object
//     .keys(rawData)
//     .map(label => createLineChart(label, rawData[label]))
// );

