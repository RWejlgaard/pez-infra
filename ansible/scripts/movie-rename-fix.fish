#!/usr/bin/env fish

cd /hdd/movies

for i in (find . -name "*www.UIndex.org    -    *")
    mv $i (echo $i | sed 's/www.UIndex.org    -    //')
end
