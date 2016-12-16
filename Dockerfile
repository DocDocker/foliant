FROM ubuntu
LABEL authors="Konstantin Molchanov <moigagoo@live.com>"

RUN apt-get update; apt-get install -y \
    texlive-latex-base \
    texlive-fonts-recommended \
    texlive-generic-recommended \
    texlive-lang-english \
    texlive-lang-cyrillic \
    latex-xcolor \
    texlive-fonts-extra \
    texlive-generic-extra \
    texlive-math-extra \
    texlive-latex-extra \
    texlive-bibtex-extra \
    texlive-xetex
RUN apt-get install -y pandoc
RUN apt-get install -y python3 python3-pip
RUN pip3 install "foliant[all]>=0.2.7"

ENTRYPOINT ["foliant"]