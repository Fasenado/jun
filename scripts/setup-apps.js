const { execSync } = require('child_process');
const path = require('path');
const fs = require('fs');

const root = path.resolve(__dirname, '..');
const flightsPath = path.join(root, '_repos', 'flights-tracker');
const xrayPath = path.join(root, '_repos', 'xray-visualizer');

function run(cmd, cwd) {
  console.log(`> ${cmd} (in ${cwd || root})`);
  execSync(cmd, { cwd: cwd || root, stdio: 'inherit' });
}

if (fs.existsSync(flightsPath)) {
  console.log('\n--- Building Flight Tracker ---');
  run('npm install', flightsPath);
  run('npm run build', flightsPath);
} else {
  console.warn('_repos/flights-tracker not found, skipping');
}

if (fs.existsSync(xrayPath)) {
  console.log('\n--- Building X-Ray Visualizer ---');
  run('npm install', xrayPath);
  run('npm run build', xrayPath);
} else {
  console.warn('_repos/xray-visualizer not found, skipping');
}

console.log('\n--- Apps built ---');
