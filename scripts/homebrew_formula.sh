#!/bin/sh
# Writes the Homebrew formula for a published release to stdout:
#   scripts/homebrew_formula.sh v0.1.0 checksums.txt > polaris.rb
# The checksums are the release's own checksums.txt, so the formula installs
# exactly the archives that were published.
set -eu

tag=$1
checksums=$2
version=${tag#v}
base="https://github.com/itsmycargo/polaris-cli-releases/releases/download/$tag"

# url and sha256 for one archive, or fail if the release doesn't have it.
archive() {
  file="polaris_${version}_$1.tar.gz"
  sum=$(awk -v f="$file" '$2 == f { print $1 }' "$checksums")
  if [ -z "$sum" ]; then
    echo "no $file in $checksums" >&2
    exit 1
  fi
  printf '      url "%s/%s"\n      sha256 "%s"\n' "$base" "$file" "$sum"
}

# Each one first: a missing archive stops the script before it writes anything.
darwin_arm64=$(archive darwin_arm64)
darwin_amd64=$(archive darwin_amd64)
linux_arm64=$(archive linux_arm64)
linux_amd64=$(archive linux_amd64)

cat <<RUBY
# Written by itsmycargo/polaris-cli-releases on each release; don't edit.
class Polaris < Formula
  desc "Command-line tool for ItsMyCargo freight quotes, bookings and tracking"
  homepage "https://github.com/itsmycargo/polaris-cli-releases"
  version "$version"

  on_macos do
    on_arm do
${darwin_arm64}
    end
    on_intel do
${darwin_amd64}
    end
  end

  on_linux do
    on_arm do
${linux_arm64}
    end
    on_intel do
${linux_amd64}
    end
  end

  def install
    bin.install "polaris"
    generate_completions_from_executable(bin/"polaris", "completion")
  end

  def caveats
    <<~EOS
      To teach Claude Code or Codex to use polaris, install its agent skill:
        polaris skill install
      and again after each upgrade.
    EOS
  end

  test do
    assert_equal "polaris #{version}", shell_output("#{bin}/polaris version").strip
  end
end
RUBY
