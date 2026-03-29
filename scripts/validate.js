#!/usr/bin/env node

/**
 * OpenClaw Course Validator
 * Validates the course HTML structure and content
 */

const fs = require('fs');
const path = require('path');

const HTML_FILE = path.join(__dirname, '..', 'openclaw-course.html');

function validateCourse() {
  console.log('🔍 Validating OpenClaw Course...\n');
  
  if (!fs.existsSync(HTML_FILE)) {
    console.error('❌ Error: openclaw-course.html not found');
    process.exit(1);
  }
  
  const content = fs.readFileSync(HTML_FILE, 'utf8');
  let passed = 0;
  let failed = 0;
  const errors = [];
  const warnings = [];
  
  // Test 1: Basic HTML structure
  console.log('1. Checking basic HTML structure...');
  if (content.includes('<!DOCTYPE html>')) {
    console.log('   ✅ DOCTYPE declaration found');
    passed++;
  } else {
    console.log('   ❌ Missing DOCTYPE declaration');
    errors.push('Missing DOCTYPE declaration');
    failed++;
  }
  
  if (content.includes('<html') && content.includes('</html>')) {
    console.log('   ✅ HTML tags found');
    passed++;
  } else {
    console.log('   ❌ Missing HTML tags');
    errors.push('Missing HTML tags');
    failed++;
  }
  
  if (content.includes('<head') && content.includes('</head>')) {
    console.log('   ✅ HEAD section found');
    passed++;
  } else {
    console.log('   ❌ Missing HEAD section');
    errors.push('Missing HEAD section');
    failed++;
  }
  
  if (content.includes('<body') && content.includes('</body>')) {
    console.log('   ✅ BODY section found');
    passed++;
  } else {
    console.log('   ❌ Missing BODY section');
    errors.push('Missing BODY section');
    failed++;
  }
  
  // Test 2: Required meta tags
  console.log('\n2. Checking meta tags...');
  if (content.includes('charset="UTF-8"')) {
    console.log('   ✅ UTF-8 charset found');
    passed++;
  } else {
    console.log('   ⚠️  UTF-8 charset not found');
    warnings.push('UTF-8 charset not found');
  }
  
  if (content.includes('viewport')) {
    console.log('   ✅ Viewport meta tag found');
    passed++;
  } else {
    console.log('   ⚠️  Viewport meta tag not found');
    warnings.push('Viewport meta tag not found');
  }
  
  // Test 3: Course structure
  console.log('\n3. Checking course structure...');
  const moduleCount = (content.match(/class="module"/g) || []).length;
  if (moduleCount >= 1) {
    console.log(`   ✅ Found ${moduleCount} modules`);
    passed++;
  } else {
    console.log('   ❌ No modules found');
    errors.push('No modules found');
    failed++;
  }
  
  const quizCount = (content.match(/class="quiz"/g) || []).length;
  if (quizCount >= 1) {
    console.log(`   ✅ Found ${quizCount} quizzes`);
    passed++;
  } else {
    console.log('   ⚠️  No quizzes found');
    warnings.push('No quizzes found');
  }
  
  // Test 4: Interactive elements
  console.log('\n4. Checking interactive elements...');
  if (content.includes('addEventListener')) {
    console.log('   ✅ JavaScript event listeners found');
    passed++;
  } else {
    console.log('   ⚠️  No JavaScript event listeners found');
    warnings.push('No JavaScript event listeners found');
  }
  
  if (content.includes('querySelector') || content.includes('getElementById')) {
    console.log('   ✅ DOM manipulation found');
    passed++;
  } else {
    console.log('   ⚠️  No DOM manipulation found');
    warnings.push('No DOM manipulation found');
  }
  
  // Test 5: Accessibility
  console.log('\n5. Checking accessibility...');
  const h1Count = (content.match(/<h1/g) || []).length;
  if (h1Count === 1) {
    console.log('   ✅ Exactly one H1 heading found');
    passed++;
  } else if (h1Count > 1) {
    console.log(`   ⚠️  ${h1Count} H1 headings found (should be 1)`);
    warnings.push(`Multiple H1 headings found: ${h1Count}`);
  } else {
    console.log('   ⚠️  No H1 heading found');
    warnings.push('No H1 heading found');
  }
  
  const imgCount = (content.match(/<img/g) || []).length;
  const altCount = (content.match(/alt="/g) || []).length;
  if (imgCount === 0 || imgCount === altCount) {
    console.log(`   ✅ All ${imgCount} images have alt text`);
    passed++;
  } else {
    console.log(`   ⚠️  ${altCount}/${imgCount} images have alt text`);
    warnings.push(`Missing alt text: ${altCount}/${imgCount} images`);
  }
  
  // Test 6: File size
  console.log('\n6. Checking file size...');
  const stats = fs.statSync(HTML_FILE);
  const sizeKB = (stats.size / 1024).toFixed(2);
  console.log(`   File size: ${sizeKB} KB`);
  
  if (stats.size < 100 * 1024) { // Less than 100KB
    console.log('   ✅ File size is reasonable');
    passed++;
  } else if (stats.size < 500 * 1024) { // Less than 500KB
    console.log('   ⚠️  File is somewhat large');
    warnings.push(`File is somewhat large: ${sizeKB} KB`);
  } else {
    console.log('   ⚠️  File is very large');
    warnings.push(`File is very large: ${sizeKB} KB`);
  }
  
  // Summary
  console.log('\n' + '='.repeat(50));
  console.log('📊 VALIDATION SUMMARY');
  console.log('='.repeat(50));
  console.log(`Tests passed: ${passed}`);
  console.log(`Tests failed: ${failed}`);
  console.log(`Warnings: ${warnings.length}`);
  
  if (errors.length > 0) {
    console.log('\n❌ ERRORS:');
    errors.forEach(error => console.log(`  - ${error}`));
  }
  
  if (warnings.length > 0) {
    console.log('\n⚠️  WARNINGS:');
    warnings.forEach(warning => console.log(`  - ${warning}`));
  }
  
  if (failed === 0) {
    console.log('\n✅ All critical tests passed!');
    console.log('The course is ready for deployment.');
  } else {
    console.log(`\n❌ ${failed} critical errors found.`);
    console.log('Please fix the errors before deployment.');
    process.exit(1);
  }
  
  return {
    passed,
    failed,
    warnings,
    errors,
    fileSize: sizeKB,
    modules: moduleCount,
    quizzes: quizCount
  };
}

// Run if called directly
if (require.main === module) {
  validateCourse();
}

module.exports = { validateCourse };