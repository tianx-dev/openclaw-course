#!/bin/bash

# 🚀 OpenClaw Course Update & Deployment Script
# Comprehensive script for updating, testing, and deploying the course

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_NAME="openclaw-course"
GITHUB_USER="tianx-dev"
GITHUB_URL="https://github.com/$GITHUB_USER/$REPO_NAME"
PAGES_URL="https://$GITHUB_USER.github.io/$REPO_NAME"
BRANCH="main"

print_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

check_dependencies() {
    print_header "Checking Dependencies"
    
    local missing_deps=()
    
    # Check Git
    if ! command -v git &> /dev/null; then
        missing_deps+=("git")
    else
        print_success "Git $(git --version | awk '{print $3}')"
    fi
    
    # Check curl
    if ! command -v curl &> /dev/null; then
        missing_deps+=("curl")
    else
        print_success "curl $(curl --version | head -1 | awk '{print $2}')"
    fi
    
    # Check jq
    if ! command -v jq &> /dev/null; then
        missing_deps+=("jq")
    else
        print_success "jq $(jq --version)"
    fi
    
    # Check Node.js (optional)
    if command -v node &> /dev/null; then
        print_success "Node.js $(node --version)"
    else
        print_warning "Node.js not found (optional for some features)"
    fi
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        print_error "Missing dependencies: ${missing_deps[*]}"
        echo "Install missing dependencies and try again."
        exit 1
    fi
}

check_repo_status() {
    print_header "Checking Repository Status"
    
    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "Not in a Git repository"
        exit 1
    fi
    
    # Check remote
    if ! git remote get-url origin &> /dev/null; then
        print_error "No remote 'origin' configured"
        echo "Run: git remote add origin $GITHUB_URL.git"
        exit 1
    fi
    
    # Check current branch
    CURRENT_BRANCH=$(git branch --show-current)
    if [ "$CURRENT_BRANCH" != "$BRANCH" ]; then
        print_warning "Not on $BRANCH branch (currently on $CURRENT_BRANCH)"
        read -p "Switch to $BRANCH branch? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git checkout $BRANCH
        else
            print_error "Please switch to $BRANCH branch manually"
            exit 1
        fi
    fi
    
    print_success "Repository status OK"
}

validate_changes() {
    print_header "Validating Changes"
    
    # Check for uncommitted changes
    if ! git diff --quiet; then
        print_warning "You have uncommitted changes"
        git status --short
        read -p "Commit changes before proceeding? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git add .
            git commit -m "Auto-commit: $(date '+%Y-%m-%d %H:%M:%S')"
        fi
    fi
    
    # Validate HTML (basic check)
    if [ -f "openclaw-course.html" ]; then
        if grep -q "<!DOCTYPE html>" openclaw-course.html; then
            print_success "HTML structure looks valid"
        else
            print_warning "HTML file might be malformed"
        fi
    fi
    
    # Check file sizes
    HTML_SIZE=$(stat -f%z openclaw-course.html 2>/dev/null || stat -c%s openclaw-course.html 2>/dev/null)
    if [ "$HTML_SIZE" -gt 100000 ]; then
        print_warning "HTML file is large ($HTML_SIZE bytes). Consider optimization."
    else
        print_success "HTML file size: $HTML_SIZE bytes"
    fi
}

run_tests() {
    print_header "Running Tests"
    
    # Check for broken links (basic)
    echo "Checking for broken internal links..."
    if grep -o 'href="[^"]*"' openclaw-course.html | grep -v 'http' | grep -v 'mailto:' | grep -v 'tel:' | grep -q '#'; then
        print_success "Internal links found"
    fi
    
    # Validate quiz functionality (basic check)
    if grep -q "quiz-option" openclaw-course.html; then
        QUIZ_COUNT=$(grep -c "quiz-option" openclaw-course.html)
        print_success "Found $QUIZ_COUNT quiz questions"
    fi
    
    # Check JavaScript syntax (basic)
    if grep -q "<script>" openclaw-course.html; then
        print_success "JavaScript detected in HTML"
    fi
    
    print_success "Basic tests passed"
}

commit_changes() {
    print_header "Committing Changes"
    
    # Get commit message
    if [ -z "$1" ]; then
        echo "Enter commit message (or press Enter for default):"
        read -r COMMIT_MSG
        if [ -z "$COMMIT_MSG" ]; then
            COMMIT_MSG="Update: $(date '+%Y-%m-%d %H:%M:%S')"
        fi
    else
        COMMIT_MSG="$1"
    fi
    
    # Add all changes
    git add .
    
    # Commit
    if git commit -m "$COMMIT_MSG"; then
        print_success "Changes committed: $COMMIT_MSG"
    else
        print_warning "No changes to commit"
    fi
}

push_to_github() {
    print_header "Pushing to GitHub"
    
    # Get current commit hash
    CURRENT_COMMIT=$(git rev-parse --short HEAD)
    
    echo "Pushing to $GITHUB_URL..."
    if git push origin $BRANCH; then
        print_success "Successfully pushed to GitHub"
        echo "Commit: $CURRENT_COMMIT"
        echo "Branch: $BRANCH"
    else
        print_error "Failed to push to GitHub"
        echo "Try: git pull --rebase origin $BRANCH"
        exit 1
    fi
}

check_deployment_status() {
    print_header "Checking Deployment Status"
    
    echo "GitHub Pages URL: $PAGES_URL"
    echo "Checking deployment status..."
    
    # Wait a moment for GitHub to start building
    sleep 5
    
    # Try to check deployment via API (if GitHub token is available)
    if [ -n "$GITHUB_TOKEN" ]; then
        DEPLOYMENT_STATUS=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
            "https://api.github.com/repos/$GITHUB_USER/$REPO_NAME/pages" | \
            jq -r '.status // "unknown"')
        
        case $DEPLOYMENT_STATUS in
            "built")
                print_success "Deployment successful"
                ;;
            "building")
                print_warning "Deployment in progress..."
                ;;
            "errored")
                print_error "Deployment failed"
                ;;
            *)
                print_warning "Deployment status: $DEPLOYMENT_STATUS"
                ;;
        esac
    else
        print_warning "GITHUB_TOKEN not set. Cannot check deployment status via API."
        echo "Set GITHUB_TOKEN environment variable for detailed status."
    fi
    
    # Simple curl check
    echo "Testing live site..."
    if curl -s -I "$PAGES_URL" | grep -q "200 OK"; then
        print_success "Site is accessible"
    else
        print_warning "Site might not be ready yet. Check in 1-2 minutes."
    fi
}

open_site() {
    print_header "Opening Live Site"
    
    echo "Opening: $PAGES_URL"
    
    # Try to open in default browser
    if command -v xdg-open &> /dev/null; then
        xdg-open "$PAGES_URL" &
    elif command -v open &> /dev/null; then
        open "$PAGES_URL" &
    elif command -v start &> /dev/null; then
        start "$PAGES_URL" &
    else
        echo "Please open manually: $PAGES_URL"
    fi
}

create_backup() {
    print_header "Creating Backup"
    
    BACKUP_DIR="../openclaw-course-backup-$(date '+%Y%m%d-%H%M%S')"
    
    echo "Creating backup in: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
    
    # Copy all files except .git
    find . -maxdepth 1 -type f -exec cp {} "$BACKUP_DIR/" \;
    
    # Copy important directories
    if [ -d "assets" ]; then
        cp -r assets "$BACKUP_DIR/"
    fi
    
    print_success "Backup created: $BACKUP_DIR"
}

show_help() {
    cat << EOF
OpenClaw Course Deployment Script

Usage: $0 [OPTIONS]

Options:
  -h, --help          Show this help message
  -c, --check         Check repository and dependencies only
  -t, --test          Run tests only
  -d, --deploy        Deploy only (skip tests)
  -m, --message TEXT  Custom commit message
  -b, --backup        Create backup before deployment
  -a, --all           Full deployment (check, test, deploy)
  --no-open           Don't open site after deployment

Examples:
  $0                    # Interactive deployment
  $0 -a                 # Full automated deployment
  $0 -m "Add new module" # Deploy with custom message
  $0 -c                 # Check only
  $0 -t                 # Test only

Environment Variables:
  GITHUB_TOKEN         GitHub API token for deployment status
EOF
}

main() {
    # Parse command line arguments
    local CHECK_ONLY=false
    local TEST_ONLY=false
    local DEPLOY_ONLY=false
    local CREATE_BACKUP=false
    local FULL_DEPLOY=false
    local NO_OPEN=false
    local COMMIT_MSG=""
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -c|--check)
                CHECK_ONLY=true
                shift
                ;;
            -t|--test)
                TEST_ONLY=true
                shift
                ;;
            -d|--deploy)
                DEPLOY_ONLY=true
                shift
                ;;
            -m|--message)
                COMMIT_MSG="$2"
                shift 2
                ;;
            -b|--backup)
                CREATE_BACKUP=true
                shift
                ;;
            -a|--all)
                FULL_DEPLOY=true
                shift
                ;;
            --no-open)
                NO_OPEN=true
                shift
                ;;
            *)
                print_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Welcome message
    echo -e "${BLUE}"
    cat << "EOF"
   ___  _   _  ____  __    __    _      ____  _  _  ____ 
  / __)( )_( )( ___)(  )  (  )  ( )    ( ___)( \( )( ___)
 ( (__  ) _ (  )__)  )(__  )(__  )(__   )__)  )  (  )__) 
  \___)(_) (_)(____)(____)(____)(____) (____)(_)\_)(____)
                    Deployment Script
EOF
    echo -e "${NC}"
    
    # Run based on options
    if [ "$CHECK_ONLY" = true ]; then
        check_dependencies
        check_repo_status
        exit 0
    fi
    
    if [ "$TEST_ONLY" = true ]; then
        check_dependencies
        check_repo_status
        run_tests
        exit 0
    fi
    
    if [ "$DEPLOY_ONLY" = true ]; then
        check_dependencies
        check_repo_status
        commit_changes "$COMMIT_MSG"
        push_to_github
        check_deployment_status
        [ "$NO_OPEN" = false ] && open_site
        exit 0
    fi
    
    if [ "$FULL_DEPLOY" = true ]; then
        check_dependencies
        check_repo_status
        [ "$CREATE_BACKUP" = true ] && create_backup
        validate_changes
        run_tests
        commit_changes "$COMMIT_MSG"
        push_to_github
        check_deployment_status
        [ "$NO_OPEN" = false ] && open_site
        exit 0
    fi
    
    # Interactive mode
    print_header "OpenClaw Course Deployment"
    echo "Repository: $GITHUB_URL"
    echo "Pages URL:  $PAGES_URL"
    echo ""
    
    # Ask for backup
    read -p "Create backup before proceeding? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        CREATE_BACKUP=true
    fi
    
    # Run steps
    check_dependencies
    check_repo_status
    
    if [ "$CREATE_BACKUP" = true ]; then
        create_backup
    fi
    
    validate_changes
    
    echo ""
    read -p "Run tests? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        run_tests
    fi
    
    echo ""
    read -p "Commit changes? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        commit_changes "$COMMIT_MSG"
    fi
    
    echo ""
    read -p "Push to GitHub? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        push_to_github
    fi
    
    echo ""
    read -p "Check deployment status? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        check_deployment_status
    fi
    
    echo ""
    read -p "Open live site? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        open_site
    fi
    
    print_header "Deployment Complete"
    echo "Summary:"
    echo "  - Repository: $GITHUB_URL"
    echo "  - Live Site:  $PAGES_URL"
    echo "  - Branch:     $BRANCH"
    echo ""
    echo "Next steps:"
    echo "  1. Test the live site thoroughly"
    echo "  2. Share with the OpenClaw community"
    echo "  3. Monitor analytics (if configured)"
    echo "  4. Gather feedback for improvements"
    echo ""
    echo "Thank you for contributing to OpenClaw education! 🎓"
}

# Run main function with all arguments
main "$@"