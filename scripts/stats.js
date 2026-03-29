#!/usr/bin/env node

/**
 * OpenClaw Course Statistics Generator
 * Generates detailed statistics about the course
 */

const fs = require('fs');
const path = require('path');
const chalk = require('chalk');

// Check if chalk is available, otherwise use fallback
const hasChalk = (() => {
  try {
    require.resolve('chalk');
    return true;
  } catch {
    return false;
  }
})();

const colors = hasChalk ? chalk : {
  green: (text) => text,
  blue: (text) => text,
  yellow: (text) => text,
  red: (text) => text,
  magenta: (text) => text,
  cyan: (text) => text,
  bold: (text) => text
};

async function generateStats() {
  console.log(colors.blue.bold('📊 OpenClaw Course Statistics\n'));
  
  const htmlPath = path.join(__dirname, '..', 'openclaw-course.html');
  
  if (!fs.existsSync(htmlPath)) {
    console.error(colors.red('Error: openclaw-course.html not found'));
    process.exit(1);
  }
  
  const htmlContent = fs.readFileSync(htmlPath, 'utf8');
  
  // Basic file stats
  const fileStats = fs.statSync(htmlPath);
  const fileSizeKB = (fileStats.size / 1024).toFixed(2);
  const fileSizeMB = (fileStats.size / (1024 * 1024)).toFixed(2);
  
  console.log(colors.cyan('📁 File Information:'));
  console.log(`  Size: ${fileSizeKB} KB (${fileSizeMB} MB)`);
  console.log(`  Lines: ${htmlContent.split('\n').length}`);
  console.log(`  Characters: ${htmlContent.length}`);
  
  // Count modules
  const moduleCount = (htmlContent.match(/class="module"/g) || []).length;
  console.log(`\n${colors.cyan('📚 Course Structure:')}`);
  console.log(`  Modules: ${moduleCount}`);
  
  // Count screens within modules
  const screenCount = (htmlContent.match(/class="screen"/g) || []).length;
  console.log(`  Screens: ${screenCount}`);
  console.log(`  Screens per module: ${(screenCount / moduleCount).toFixed(1)}`);
  
  // Count interactive elements
  const quizCount = (htmlContent.match(/class="quiz"/g) || []).length;
  const quizOptionCount = (htmlContent.match(/class="quiz-option"/g) || []).length;
  const translationCount = (htmlContent.match(/class="translation-block"/g) || []).length;
  const calloutCount = (htmlContent.match(/class="callout"/g) || []).length;
  const codeBlockCount = (htmlContent.match(/class="code-block"/g) || []).length;
  
  console.log(`\n${colors.cyan('🎮 Interactive Elements:')}`);
  console.log(`  Quizzes: ${quizCount}`);
  console.log(`  Quiz options: ${quizOptionCount}`);
  console.log(`  Code translations: ${translationCount}`);
  console.log(`  Callout boxes: ${calloutCount}`);
  console.log(`  Code blocks: ${codeBlockCount}`);
  
  // Count JavaScript functions
  const functionCount = (htmlContent.match(/function\s+\w+/g) || []).length;
  const eventListenerCount = (htmlContent.match(/addEventListener/g) || []).length;
  const querySelectorCount = (htmlContent.match(/querySelector/g) || []).length;
  
  console.log(`\n${colors.cyan('💻 JavaScript Analysis:')}`);
  console.log(`  Functions: ${functionCount}`);
  console.log(`  Event listeners: ${eventListenerCount}`);
  console.log(`  DOM queries: ${querySelectorCount}`);
  
  // Count CSS variables and classes
  const cssVarCount = (htmlContent.match(/var\(--/g) || []).length;
  const cssClassCount = (htmlContent.match(/class="/g) || []).length;
  const uniqueClasses = new Set();
  const classMatches = htmlContent.match(/class="([^"]+)"/g) || [];
  classMatches.forEach(match => {
    const classes = match.replace('class="', '').replace('"', '').split(' ');
    classes.forEach(cls => uniqueClasses.add(cls));
  });
  
  console.log(`\n${colors.cyan('🎨 CSS Analysis:')}`);
  console.log(`  CSS variables used: ${cssVarCount}`);
  console.log(`  Total class attributes: ${cssClassCount}`);
  console.log(`  Unique CSS classes: ${uniqueClasses.size}`);
  
  // Count images and media
  const imgCount = (htmlContent.match(/<img/g) || []).length;
  const hasAltText = (htmlContent.match(/alt="/g) || []).length;
  
  console.log(`\n${colors.cyan('🖼️ Media Analysis:')}`);
  console.log(`  Images: ${imgCount}`);
  console.log(`  Images with alt text: ${hasAltText}/${imgCount}`);
  
  // Accessibility checks
  const h1Count = (htmlContent.match(/<h1/g) || []).length;
  const h2Count = (htmlContent.match(/<h2/g) || []).length;
  const h3Count = (htmlContent.match(/<h3/g) || []).length;
  const buttonCount = (htmlContent.match(/<button/g) || []).length;
  const ariaCount = (htmlContent.match(/aria-/g) || []).length;
  
  console.log(`\n${colors.cyan('♿ Accessibility:')}`);
  console.log(`  H1 headings: ${h1Count} (should be 1)`);
  console.log(`  H2 headings: ${h2Count}`);
  console.log(`  H3 headings: ${h3Count}`);
  console.log(`  Buttons: ${buttonCount}`);
  console.log(`  ARIA attributes: ${ariaCount}`);
  
  // Calculate estimated reading/learning time
  const wordCount = htmlContent.split(/\s+/).length;
  const readingTimeMinutes = Math.ceil(wordCount / 200); // 200 words per minute
  const learningTimeMinutes = readingTimeMinutes * 3; // 3x for interactive learning
  
  console.log(`\n${colors.cyan('⏱️ Time Estimates:')}`);
  console.log(`  Word count: ${wordCount.toLocaleString()}`);
  console.log(`  Reading time: ~${readingTimeMinutes} minutes`);
  console.log(`  Learning time: ~${learningTimeMinutes} minutes (with interactions)`);
  
  // Generate summary
  console.log(`\n${colors.green.bold('📈 Summary:')}`);
  console.log(`  The course contains ${moduleCount} modules with ${screenCount} screens.`);
  console.log(`  There are ${quizCount} quizzes with ${quizOptionCount} total questions.`);
  console.log(`  The file is ${fileSizeKB} KB with ${wordCount.toLocaleString()} words.`);
  console.log(`  Estimated learning time: ${learningTimeMinutes} minutes.`);
  
  // Save stats to file
  const stats = {
    generated: new Date().toISOString(),
    fileSize: {
      bytes: fileStats.size,
      kb: parseFloat(fileSizeKB),
      mb: parseFloat(fileSizeMB)
    },
    structure: {
      modules: moduleCount,
      screens: screenCount,
      screensPerModule: parseFloat((screenCount / moduleCount).toFixed(1))
    },
    interactive: {
      quizzes: quizCount,
      quizOptions: quizOptionCount,
      translations: translationCount,
      callouts: calloutCount,
      codeBlocks: codeBlockCount
    },
    javascript: {
      functions: functionCount,
      eventListeners: eventListenerCount,
      domQueries: querySelectorCount
    },
    css: {
      variables: cssVarCount,
      classAttributes: cssClassCount,
      uniqueClasses: uniqueClasses.size
    },
    media: {
      images: imgCount,
      imagesWithAlt: hasAltText
    },
    accessibility: {
      h1: h1Count,
      h2: h2Count,
      h3: h3Count,
      buttons: buttonCount,
      aria: ariaCount
    },
    content: {
      words: wordCount,
      readingTimeMinutes: readingTimeMinutes,
      learningTimeMinutes: learningTimeMinutes
    }
  };
  
  const statsPath = path.join(__dirname, '..', 'course-stats.json');
  fs.writeFileSync(statsPath, JSON.stringify(stats, null, 2));
  console.log(`\n${colors.green('✅ Statistics saved to: course-stats.json')}`);
  
  return stats;
}

// Run if called directly
if (require.main === module) {
  generateStats().catch(console.error);
}

module.exports = { generateStats };