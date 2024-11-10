SHELL := /bin/zsh
.SHELLFLAGS := -e -o pipefail -c

setup_git_hooks:
	@mkdir -p .git/hooks
	@printf '#!/bin/bash\n\
SWIFT_LINT=/opt/homebrew/bin/swiftlint\n\
REQUIRED_VERSION="0.57.0"\n\
\n\
if [[ -e "$${SWIFT_LINT}" ]]; then\n\
    INSTALLED_VERSION=$$($${SWIFT_LINT} version)\n\
    if [[ "$${INSTALLED_VERSION}" != "$${REQUIRED_VERSION}" ]]; then\n\
        echo "⚠️  ERROR: SwiftLint version is $${INSTALLED_VERSION}. Required version is $${REQUIRED_VERSION}. Run \"make bootstrap\""\n\
        exit 1\n\
    fi\n\
    $${SWIFT_LINT} --config .swiftlint.yml --strict --quiet\n\
    RESULT=$$? # swiftlint exit value is number of errors\n\
\n\
    if [ $${RESULT} -eq 0 ]; then\n\
        echo "🎉  Well done. No violation."\n\
    fi\n\
    exit $${RESULT}\n\
else\n\
    echo "⚠️  WARNING: SwiftLint not found in $${SWIFT_LINT}"\n\
    echo "⚠️  You might want to edit .git/hooks/pre-commit to locate your swiftlint"\n\
    exit 1\n\
fi\n' > .git/hooks/pre-commit
	@chmod +x .git/hooks/pre-commit

bootstrap:
	brew bundle install
	$(MAKE) setup_git_hooks

prepare_release:
	TUIST_STATIC=1 tuist install
	TUIST_STATIC=1 tuist generate --no-binary-cache --no-open