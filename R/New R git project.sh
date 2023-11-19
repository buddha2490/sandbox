home="/Users/briancarter/icloud/work/rdata"
newrepo="$home/input"
cd $home

# create a local and github repo
/Applications/gh/bin/gh repo create input --public --clone

# Clone my template repo
cd $newrepo
git clone git@github.com:buddha2490/ProjectTemplate.git

# cleanup
rm -rf ProjectTemplate/.git
cp -a ProjectTemplate/. $newrepo
rm -rf ProjectTemplate

# Send the new project back to Github
git add --all
git commit -a -m "Initialize the input repo"
git push origin main


# Function to open the Rstudio project

rs () {
  if [ -z "$1" ] ; then
    dir="."
  else
    dir="$1"
  fi
  cmd="proj <- list.files('$dir', pattern = '*.Rproj$', full.names = TRUE); if (length(proj) > 0) { system(paste('open -na Rstudio', proj[1])) } else { cat('No .Rproj file found in directory.\n') };"
  Rscript -e $cmd
}

cd $newrepo
rs