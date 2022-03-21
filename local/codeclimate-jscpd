#!/usr/bin/env node

/** Credit codeclimate-stylelint  */

/* eslint-disable no-console */
const detectClones = require("jscpd").detectClones;
const fs = require('fs');
const glob = require('glob');
const { cosmiconfigSync } = require('cosmiconfig');
const CONFIG_PATH = "/config.json"
const CODE_PATH = "/code"


let engineConfig;
let analysisFiles;

// Set Default options
const options = {  };


function buildAndPrintIssueJson(message) {

  const currentDir = process.cwd();
  const description = `Duplicate block of code found in ${message.format} file`;
  const firstFilePath = message.duplicationA.sourceId.replace(`${currentDir}/`, '');
  const secondFilePath = message.duplicationB.sourceId.replace(`${currentDir}/`, '')


  const issueFirstFile = {
    type: 'issue',
    categories: ['Duplication'],
    check_name: 'Duplicated Code',
    description: description,
    content: { body:`Possibly duplicated from file ${secondFilePath}`},
    remediation_points: 50000,
    severity: 'minor',
    location: {
      path: firstFilePath,
      positions: {
        begin: {
          line: message.duplicationA.start.line || 1,
          column : message.duplicationA.start.column || 1
        },
        end: {
          line: message.duplicationA.end.line || 1,
          column: message.duplicationA.end.column || 1
        }
      }
    }
  };

  const issueSecondFile = {
    type: 'issue',
    categories: ['Duplication'],
    check_name: 'Duplicated Code',
    description: description,
    content: { body: `Possibly duplicated from file ${firstFilePath}`},
    remediation_points: 50000,
    severity: 'minor',
    location: {
      path: secondFilePath,
      positions: {
        begin: {
          line: message.duplicationB.start.line || 1,
          column: message.duplicationB.start.column || 1
        },
        end: {
          line: message.duplicationB.end.line || 1,
          column: message.duplicationB.end.column || 1
        }
      }
    }
  };

  process.stdout.write(`${JSON.stringify(issueFirstFile)}\u0000`);
  process.stdout.write(`${JSON.stringify(issueSecondFile)}\u0000`);
}


function prunePathsWithinSymlinks(paths) {
  // Extracts symlinked paths and filters them out, including any child paths
  const symlinks = paths.filter(p => fs.lstatSync(p).isSymbolicLink());

  return paths.filter(p => {
    let withinSymlink = false;
    symlinks.forEach(symlink => {
      if (p.indexOf(symlink) === 0) {
        withinSymlink = true;
      }
    });
    return !withinSymlink;
  });
}


function inclusionBasedFileListBuilder(includePaths) {
  // Uses glob to expand the files and directories in includePaths, filtering
  // down to match the list of desired extensions.
    const filesAnalyzed = [];

    includePaths.forEach(fileOrDirectory => {
      if (/\/$/.test(fileOrDirectory)) {
        // if it ends in a slash, expand and push
        const filesInThisDirectory = glob.sync(`${fileOrDirectory}/**/**`);
        prunePathsWithinSymlinks(filesInThisDirectory).forEach(file => {
          
            filesAnalyzed.push(file);
          
        });
      } else  {
        filesAnalyzed.push(fileOrDirectory);
      }
    });

    return filesAnalyzed;
  
}

function obtainJscpdConfig() {
  const explorerSync = cosmiconfigSync('jscpd');
  let result;

  if (options.configFile) {
    result = explorerSync.load(`${process.cwd()}/${options.configFile}`);
  } else {
    result = explorerSync.search(process.cwd());
  }

  if(result){
    return result.config;
  }
  
}


function configEngine() {
  
  if (fs.existsSync(CONFIG_PATH)) {
    engineConfig = JSON.parse(fs.readFileSync(CONFIG_PATH));

    const userConfig = engineConfig.config || {};

    if (userConfig.config) {
      options.configFile = userConfig.config;
    }

  } 
}

function analyzeFiles() {
  const jscpdConfig = obtainJscpdConfig();

  (async () => {
    const clones = await detectClones({
      path: [CODE_PATH],
      silent: true,
      ...jscpdConfig
    });

    if(clones){
      clones.forEach((duplicate)=>{
        buildAndPrintIssueJson(duplicate);
      })
    }
  })()
  
}


configEngine();
analyzeFiles();
