function ls --wraps=exa --wraps='exa -lah' --wraps='exa -lah --group-directories-first' --description 'alias ls=exa -lah --group-directories-first'
  exa -lah --group-directories-first $argv
        
end
