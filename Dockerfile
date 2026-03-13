FROM legionio/legion

COPY . /usr/src/app/lex-gemini

WORKDIR /usr/src/app/lex-gemini
RUN bundle install
