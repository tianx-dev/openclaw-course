# OpenClaw Internals Course

## Overview
This is an interactive HTML course that explains how OpenClaw works under the hood. It breaks down the architecture of your personal AI assistant into understandable concepts with visual explanations, code examples, and interactive quizzes.

## What You'll Learn
- How messages flow from your chat app to the AI and back
- The role of each OpenClaw component (Gateway, Agents, Channels, Tools)
- Why the architecture uses separation of concerns
- Practical benefits for debugging and extending OpenClaw
- Software architecture patterns you can apply elsewhere

## Course Structure
The course consists of 6 modules:

1. **Meet OpenClaw** - Introduction to the system metaphor
2. **The Gateway** - Traffic control center and authentication
3. **AI Agents** - The thinking brain with tool orchestration
4. **Channels** - Platform-specific adapters (Telegram, WhatsApp, etc.)
5. **The Complete Journey** - Step-by-step message flow
6. **Why It Matters** - Practical applications and architecture patterns

## Interactive Features
- **Code Translations**: Side-by-side code and plain English explanations
- **Quizzes**: Test your understanding with immediate feedback
- **Visual Flow**: Step-by-step diagrams of message journeys
- **Progress Tracking**: Visual indicators of your progress
- **Keyboard Navigation**: Use arrow keys to move between modules

## How to Use
1. Open `openclaw-course.html` in any modern web browser
2. Scroll through the modules (or use arrow keys)
3. Click on quiz options to test your knowledge
4. Use the progress dots at the top to jump between modules

## Technical Details
- Self-contained HTML file (no external dependencies)
- Responsive design works on mobile and desktop
- Custom CSS with accessible color scheme
- Vanilla JavaScript for interactivity
- Uses system fonts for fast loading

## Files in This Project
- `openclaw-course.html` - Complete interactive course
- `openclaw-analysis.md` - Technical analysis of OpenClaw architecture
- `README-course.md` - This documentation file

## Background
This course was created by analyzing the OpenClaw source code (https://github.com/openclaw/openclaw) and applying the codebase-to-course methodology to make complex software architecture accessible to non-technical users.

## For Developers
The course demonstrates:
- How to explain complex systems through metaphor
- Interactive teaching techniques for technical concepts
- Progressive disclosure of information
- Visual design for educational content

## License
Educational content - feel free to use and adapt for teaching software architecture concepts.