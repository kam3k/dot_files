#!/bin/bash

cd ~
dir=~/dot_files
olddir=~/dot_files_old
files="gitconfig vimrc"

if [ -d $olddir ]; then
    echo "ERROR: $olddir already exists. Delete, move, or rename it."
    exit
fi

echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
for file in $files; do
    if [ -f ~/.$file ]; then
        mv ~/.$file $olddir
    fi
done
if [ -d ~/.vim ]; then
    mv ~/.vim $olddir
fi
echo "...done"

echo "Cloning vundle..."
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
echo "...done"

for file in $files; do
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done

echo "Installing vim bundles..."
vim +BundleInstall +qall
echo "...done"
