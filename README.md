## Site Shoter

### Description

Site Shoter is a simple Ruby wrapper on wkhtmltoimage tool.

For using Site Shoter you should have wkhtmltoimage installed

You can download wkhtmltoimage from one of those links:

x64: http://wkhtmltopdf.googlecode.com/files/wkhtmltoimage-0.11.0_rc1-static-amd64.tar.bz2

x32: http://wkhtmltopdf.googlecode.com/files/wkhtmltoimage-0.11.0_rc1-static-i386.tar.bz2

### Usage

    shot.rb [OPTIONS] LINK OUTPUT_FILE

    LINK                Site URI. Should begin with http(s)://
    OUTPUT_FILE         File where result will be stored
    OPTIONS:
        -w <int>        Set screen width (default 1200)
        -h <int>        Set screen height (default is calculated
                        from page content)
        -q <int>        Output image quality (between 0 and 100, default 94)
        -f <format>     Output file format (default png)
        -e <encoding>   Set page encoding
        -ni             Images won't be downloaded
        -nj             Disable javascript

### Contacts

You can contact me via email: vizvamitra@gmail.com