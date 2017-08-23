[![Build Status](https://travis-ci.org/foliant-docs/foliant.svg?branch=master)](https://travis-ci.org/foliant-docs/foliant)

# Foliant

**Foliant** is a documentation generator that builds PDF, Docx, and TeX documents from Markdown source.

**Warning! Alpha-stage software!** The API is unstable, and there are issues with the code. With 99% probability we will rewrite Foliant before 1.0, maybe multiple times.


## Installation

There are two ways to install Foliant: natively and in Docker. We recommend using Docker because it'll save you time and effort installing dependencies.


### Native Installation

1.  Install Foliant with pip:

    ```shell
    $ pip install foliant[all]
    ```

2.  Install Pandoc and a LaTeX distrubution:

    - MacTeX for macOS with [brew](http://brew.sh/)
    - MikTeX for Windows with [scoop](http://scoop.sh/)
    - TeXLive for Linux with whater package manager you have

    > Among Linux distrubutions, Foliant was only tested on Ubuntu Xenial. See the full list of packages that must be installed in Ubuntu in the official [Foliant Dockerfile](https://hub.docker.com/r/foliant/foliant/).

3.  Use ``foliant`` command as described in [Usage](#usage).


### Docker Installation

1.  In your project directory, create a file called ``docker-compose.yml`` with the following content:

```yaml
version: '3'

services:
  foliant:
    image: foliant/foliant:latest
    volumes:
      - .:/usr/src/app
    working_dir: /usr/src/app
```

2.  Run `foliant` service with the same params as the regular `foliant` command (see [Usage](#usage)):

```shell
$ docker-compose run --rm foliant make pdf
Collecting source... Done!
Drawing diagrams... Done!
Baking output... Done!
----
Result: Dolor_sit_amet_0.1.0_23-08-2017.pdf
```

## Usage

```shell

$ foliant -h
Foliant: Markdown to PDF, Docx, ODT, and LaTeX generator powered by Pandoc.

Usage:
  foliant (build | make) <target> [--path=<project-path>]
  foliant (upload | up) <document> [--secret=<client_secret*.json>]
  foliant (swagger2markdown | s2m) <swagger-location> [--output=<output-file>]
    [--template=<jinja2-template>]
  foliant (-h | --help)
  foliant --version

Options:
  -h --help                         Show this screen.
  -v --version                      Show version.
  -p --path=<project-path>          Path to your project [default: .].
  -s --secret=<client_secret*.json> Path to Google app's client secret file.
  -o --output=<output-file>         Path to the converted Markdown file
                                    [default: swagger.md]
  -t --template=<jinja2-template>   Custom Jinja2 template for the Markdown
                                    output.
```


### `build`, `make`

Build the output in the desired format:

- PDF. Targets: pdf, p, or anything starting with "p"
- Docx. Targets: docx, doc, d, or anything starting with "d"
- TeX. Targets: tex, t, or anything starting with "t"
- Markdown. Targets: markdown, md, m, or anything starting with "m"
- Google Drive. Targets: gdrive, google, g, or anything starting with "g"

"Google Drive" format is a shortcut for building Docx and uploading it
to Google Drive.

Specify `--path` if your project dir is not the current one.

Example:

```shell
$ foliant make pdf
```


### `upload`, `up`

Upload a Docx file to Google Drive as a Google document:

```shell
$ foliant up MyFile.docx
```


### `swagger2markdown`, `s2m`

Convert a [Swagger JSON](http://swagger.io/specification/) file into Markdown using [swagger2markdown](https://github.com/moigagoo/swagger2markdown).

If `--output` is not specified, the output file is called `api.md`.

Specify `--template` to provide a custom [Jinja2](http://jinja.pocoo.org/) template to customize the output. Use the [default Swagger template](https://github.com/moigagoo/swagger2markdown/blob/master/swagger.md.j2) as a reference.

Example:

```shell
$ foliant s2m http://example.com/api/swagger.json -t templates/swagger.md.j2
```


### `apidoc2markdown`, `a2m`

Convert a [Apidoc JSON](http://apidocjs.com/) files into Markdown using [apidoc2markdown](https://github.com/moigagoo/apidoc2markdown).

If `--output` is not specified, the output file is called `api.md`.

Specify `--template` to provide a custom [Jinja2](http://jinja.pocoo.org/) template to customize the output. Use the [default Apidoc template](https://github.com/moigagoo/apidoc2markdown/blob/master/apidoc.md.j2) as a reference.

Example:

```shell
$ foliant a2m /path/to/api_data.json -t templates/apidoc.md.j2
```


## Project Layout

For Foliant to be able to build your docs, your project must conform to a particular layout:

    .
    │   config.json
    │   main.yaml
    │
    ├───references
    │       ref.docx
    │       ref.odt
    │
    ├───sources
    │   │   chapter1.md
    │   │   introduction.md
    │   │
    │   └───images
    │           Lenna.png
    │
    └───templates
            basic.tex
            company_logo.png

> **Important**
>
> After ``foliant make`` is invoked, a directory called ``foliantcache`` is created in the directory where you run Foliant. The ``foliantcache`` directory stores temporary files and included repos.
>
> The ``foliantcache`` directory should not be tracked by your version control system, because it will double your repo size at best. Add ``foliantcache`` to ``.gitignore`` or ``.hgignore``.


### config.json

Config file, mostly for Pandoc.

```js

{
    "title": "Lorem ipsum",           // Document title.
    "file_name": "Dolor_sit_amet",    // Output file name. If not set, slugified
                                      // `title` is used.
    "second_title": "Dolor sit amet", // Document subtitle.
    "lang": "english",                // Document language, "russian" or "english."
                                      // If not specified, "russian" is used.
    "company": "My Company",          // Your company name to fill in latex template.
                                      // Shown at the bottom of each page.
    "year": "2016",                   // Document publication year.
                                      // Shown at the bottom of each page.
    "title_page": "true",             // Add title page or not.
    "toc": "true",                    // Add table of contents or not.
    "tof": "true",                    // Add table of figures or not.
    "template": "basic",              // LaTeX template to use. Do NOT add ".tex"!
    "version": "1.0",                 // Document version. If set to "auto"
                                      // the version is generated automatically
                                      // based on git tag and revision number in master.
    "date": "true",                   // Add date to the title page and output
                                      // file name.
    "type": "",                       // Document type to show in latex template.
    "alt_doc_type": "",               // Additional document type in latex template.
    "filters": ["filter1", "filter2"] // Pandoc filters.
    "git": {                          // Git aliases for includes.
    "foliant": "git@github.com:foliant-docs/foliant.git" // Git alias.
    }
}
```

For historic reasons, all config values should be strings, even if they *mean* a number or boolean value.


### main.yaml

Contents file. Here, you define the order of the chapters of your project:

```yaml
chapters:
    - introduction
    - chapter1
    - chapter2
```


### references/

Directory with the Docx and ODT reference files. They **must** be called `ref.docx` and `ref.odt`.


### sources/

Directory with the Markdown source file of your project.


### sources/images/

Images that can be embedded in the source files. When embedding an image, **do not** prepend it with `images/`:

```markdown
  ![](image1.png)        # right
  ![](images/image1.png) # wrong
```


### templates/

LaTeX templates used to build PDF, Docx, and TeX files. The template to use in build is configured in `config.json`.


## Including External Markdown Files in Sources

Foliant allows to include Markdown sources from external files. The file can be located on the disk or in a remote git repository.

When you include a file from a git repo, the whole repo is cloned. The repo is cloned only once and is updated during subsequent includes.

Foliant attempts to locate the images referenced in the included documents. First, it checks the path specified in the image directive and 'image' and 'graphics' directories. If the image is not there, it goes one level up and repeats the search. If it reaches root and doesn't find the image, it returns '.'.


### Basic Usage

Here is a local include:

```markdown
  {{ ../../external.md }}
```

> **Note**
>
> If you use Foliant in a Docker container, local includes pointing outside the project directory will not be resolved. That's because only the project directory is mounted inside the container.
> 
> To work around that, mount the directories with the localy included files manually.

Here is an include from git:

```markdown
{{ <git@github.com:foliant-docs/foliant.git>path/to/external.md }}
```

Repo URL can be provided in https, ssh, or git protocol.

**Note**

If you use Foliant in a Docker container, use https protocol. Otherwise,
you'll be prompted by git to add the repo host to ``known_hosts``.

If the repo is aliased as "myrepo" in `config.json`_, you can use the alias
instead of the repo URL:

```markdown
{{ <myrepo>path/to/external.md }}
```

You can also specify a particular revision (branch, tag, or commit):

```markdown
{{ <myrepo#mybranch>path/to/external.md }}
```


### Extract Document Part Between Headings

It is possible to include only a part of a document between two headings, a heading and document end, or document beginning and a heading.

Extract part from the heading "From Head" to the next heading of the same level or the end of the document:

```markdown
{{ external.md#From Head }}
```

From "From Head" to "To Head" (disregarding their levels):

```markdown
{{ external.md#From Head:To Head }}
```

From the beginning of the document to "To Head":

```markdown
{{ external.md#:To Head }}
```

All the same notations work with remote includes:

```markdown
{{ <myrepo>external.md#From Head:To Head }}
```


### Heading Options

If you want to include a document but set your own heading, strip the original heading with `nohead` option:

```markdown
{{ external.md#From Head | nohead }}
```

If there is no opening heading, the included content is left unmodified.

You can also set the level for the opening heading for the included source:

```markdown
{{ external.md#From Head | sethead:3 }}
```

The options can be combined:

```markdown
{{ external.md#From Head | nohead, sethead:3 }}
```


### File Lookup

You can include a file knowing only its name, without knowing the full path. Foliant will look for the file recursively starting from the specified directory: for a remote include, it's the repo root directory; for a local one, it's the directory you specify in the path.

Here, Foliant will look for the file in the repo directory:

```markdown
{{ <myrepo>^external.md }}
```

In this case, Foliant will go one level up from the directory with the document containing the include and look for `external.md` recursively:

```markdown
{{ ../^external.md }}
```


### Nested Includes

Included files can contain includes themselves.


### Include Frenzy!

```markdown
{{ <myrepo#mybranch>path/^external.md#From Heading:To Heading | nohead, sethead:3 }}
```


## Uploading to Google Drive

To upload a Docx file to Google Drive as a Google document, use
`foliant upload MyFile.docx` or `foliant build gdrive`, which is
a shortcut for generating a Docx file and uploading it.

For the upload to work, you need to have a so called *client secret* file.
Foliant looks for `client_secrets.json` file in the current directory.

Client secret file is obtained through Google API Console. You probably don't
need to obtain it yourself. The person who told you to use Foliant should
provide you this file as well.


## Embedding seqdiag Diagrams

Foliant lets you embed [seqdiag](http://blockdiag.com/en/seqdiag/>) diagrams.

To embed a diagram, put its definition in a fenced code block:

```markdown
    ```seqdiag Optional single-line caption
    seqdiag {
    browser  -> webserver [label = "GET /index.html"];
    browser <-- webserver;
    browser  -> webserver [label = "POST /blog/comment"];
                webserver  -> database [label = "INSERT comment"];
                webserver <-- database;
    browser <-- webserver;
    }
    ```
```

This is transformed into `![Optional single-line caption](diagrams/123-qwe-456-asd.png)`, where `diagrams/123-qwe-456-asd.png` is an image generated from the diagram definition.


### Customizing Diagrams

To use a custom font, create the file `$HOME/.blockdiagrc` and define the full path to the font ([ref](http://blockdiag.com/en/seqdiag/introduction.html#font-configuration)):

```shell
$ cat $HOME/.blockdiagrc
[seqdiag]
fontpath = /usr/share/fonts/truetype/ttf-dejavu/DejaVuSerif.ttf
```

You can define [other params](http://blockdiag.com/en/seqdiag/sphinxcontrib.html#configuration-file-options) as well (remove `seqdiag_` from the beginning of the param name).


## Troubleshooting

### LaTeX Error: File \`xetex.def' not found.

Install graphics.def with MikTeX Package Manager (usually invoked with `mpm` command).
