#!/bin/sh

web_tree_sitter_files="README.md package.json tree-sitter-web.d.ts tree-sitter.js tree-sitter.wasm"

tree_sitter_version="v0.20.1"
tree_sitter_patch="tree-sitter.patch"
tree_sitter_dir=$(mktemp -d 2>/dev/null || mktemp -d -t 'tree-sitter')

git clone                                        \
	-c advice.detachedHead=false --quiet           \
	--depth=1 --branch=$tree_sitter_version        \
	https://github.com/tree-sitter/tree-sitter.git \
	"$tree_sitter_dir"

cp "$tree_sitter_patch" "$tree_sitter_dir"

pushd "$tree_sitter_dir" >/dev/null
git apply "$tree_sitter_patch"
sh script/build-wasm
popd >/dev/null

cp "$tree_sitter_dir/LICENSE" .
for file in $web_tree_sitter_files; do
  cp "$tree_sitter_dir/lib/binding_web/$file" .
done
