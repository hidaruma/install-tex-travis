#!/bin/bash

DIRNAME=tl-`date +%Y_%m_%d_%H_%M_%S`

echo "make the install directory: $DIRNAME"
mkdir $DIRNAME
cd $DIRNAME

if [[ $TRAVIS_OS_NAME == 'osx' ]]; then
  curl -L -O http://mirrors.acm.jhu.edu/ctan/systems/mac/mactex/mactex-basictex-20161009.pkg
  sudo installer -pkg BasicTeX.pkg -target /
  rm BasicTeX.pkg
  export PATH=$PATH:/Library/TeX/texbin
 
else
  wget http://ctan.mirror.rafal.ca/systems/texlive/tlnet/install-tl-unx.tar.gz
  tar zxvf install-tl-unx.tar.gz
  cd install-tl-*
  cat << EOF > ./small.profile
selected_scheme scheme-small
TEXDIR $HOME/texlive/2016
TEXMFCONFIG $HOME/.texlive2016/texmf-config
TEXMFHOME $HOME/texmf
TEXMFLOCAL $HOME/texlive/texmf-local
TEXMFSYSCONFIG $HOME/texlive/2016/texmf-config
TEXMFSYSVAR $HOME/texlive/2016/texmf-var
TEXMFVAR $HOME/.texlive2016/texmf-var
binary_x86_64-linux 1
option_doc 0
option_src 0
EOF
  ./install-tl -profile ./small.profile -repository http://ctan.mirror.rafal.ca/systems/texlive/tlnet/
  export PATH=$PATH:$HOME/texlive/2016/bin/x86_64-linux
  tlmgr init-usertree
  cd ..
fi

cd ..

echo "remove the install directory"
rm -rf $DIRNAME
