const { 
  createSqlQueries,
  processRawDataFiles, 
  getTableOfResults, 
  drawIndividualBarCharts,
  drawIndividualLineCharts,
} = require('./utils');

createSqlQueries();

// const data = processRawDataFiles();
// const results = getTableOfResults(data.yearCounts);
// console.log(results);

// Promise.all([
//   drawIndividualLineCharts(data.weekCounts),
//   drawIndividualBarCharts(data.yearCounts)
// ]).then((x) => console.log('All charts written'));

