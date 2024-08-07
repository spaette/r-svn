% File src/library/grDevices/man/pdf.Rd
% Part of the R package, https://www.R-project.org
% Copyright 1995-2024 R Core Team
% Distributed under GPL 2 or later

\name{pdf}
\alias{pdf}
\encoding{UTF-8}

\title{PDF Graphics Device}
%% The definitive doc is the source :-)
\description{
  \code{pdf} starts the graphics device driver for producing PDF
  graphics.
}
\usage{
pdf(file = if(onefile) "Rplots.pdf" else "Rplot\%03d.pdf",
    width, height, onefile, family, title, fonts, version,
    paper, encoding, bg, fg, pointsize, pagecentre, colormodel,
    useDingbats, useKerning, fillOddEven, compress,
    timestamp, producer, author)
}
\arguments{
  \item{file}{a character string giving the file path.
    See the section \sQuote{File specifications} for further details.
  }
  \item{width, height}{the width and height of the graphics region in
    inches.  The default values are \code{7}.}
  \item{onefile}{logical: if true (the default) allow multiple figures
    in one file.  If false, generate a file with name containing the page
    number for each page.  Defaults to \code{TRUE}, and forced to true
    if \code{file} is a pipe.}
  \item{family}{the initial font family to be used, normally as a
    character string.  See the section \sQuote{Families}.  Defaults to
    \code{"Helvetica"}.}
  \item{title}{title string to embed as the \samp{/Title} field in the
    document metadata.  Defaults to \code{"R Graphics Output"};
    use an empty string (\code{""}) to omit the field.}
  \item{fonts}{a character vector specifying \R graphics font family
    names for additional fonts which will be included in the PDF file.
    Defaults to \code{NULL}.}
  \item{version}{a string describing the PDF version that will be
    required to view the output.  This is a minimum, and will be
    increased (with a warning) if necessary.  Defaults to \code{"1.4"},
    but see \sQuote{Details}.}
  \item{paper}{the target paper size.  The choices are
    \code{"a4"}, \code{"letter"}, \code{"legal"} (or \code{"us"}) and
    \code{"executive"} (and these can be capitalized), or \code{"a4r"}
    and \code{"USr"} for rotated (\sQuote{landscape}).
    The default is \code{"special"}, which means that the \code{width}
    and \code{height} specify the paper size.  A further choice is
    \code{"default"}; if this is selected, the
    paper size is taken from the option \code{"papersize"}
    if that is set and as \code{"a4"} if it is unset or empty.
    Defaults to \code{"special"}.
  }
  \item{encoding}{the name of an encoding file.  Defaults to
    \code{"default"}.  The latter is interpreted
    \describe{
      \item{on Unix-alikes}{
	as \file{"ISOLatin1.enc"} unless the locale is recognized as
    corresponding to a language using ISO 8859-\{2,5,7,13,15\} or \I{KOI8}-\{R,U\}.
      }
      \item{on Windows}{
    as \file{"CP1250.enc"} (Central European), \code{"CP1251.enc"} (Cyrillic),
    \code{"CP1253.enc"} (Greek) or \code{"CP1257.enc"} (Baltic) if one
    of those codepages is in use, otherwise \file{"WinAnsi.enc"}
    (codepage 1252).
      }
    }
    The file is looked for in the \file{enc} directory of package
    \pkg{grDevices} if the path does not contain a path separator.  An
    extension \code{".enc"} can be omitted.
  }
  \item{bg}{the initial background color to be used.  Defaults to
    \code{"transparent"}.}
  \item{fg}{the initial foreground color to be used.  Defaults to
   \code{"black"}.}
  \item{pointsize}{the default point size to be used.  Strictly
    speaking, in \abbr{bp}, that is 1/72 of an inch, but approximately in
    points.  Defaults to \code{12}.}
  \item{pagecentre}{logical: should the device region be centred on the
    page? -- is only relevant for \code{paper != "special"}.
    Defaults to \code{TRUE}.}
  \item{colormodel}{a character string describing the color model:
    currently allowed values are \code{"srgb"}, \code{"gray"} (or
    \code{"grey"}) and \code{"cmyk"}.  Defaults to \code{"srgb"}.  See section
    \sQuote{Color models}.}
  \item{useDingbats}{logical.  Should small circles be rendered
    \emph{via} the Dingbats font?  Defaults to \code{FALSE}.
    If \code{TRUE}, this can produce smaller and better output, but
    can cause font display problems in broken PDF viewers: although this
    font is one of the 14 guaranteed to be available in all PDF viewers,
    that guarantee is not always honoured.

    For Unix-alikes (including macOS) see the \sQuote{Note} for a
    possible fix for some viewers.}
  \item{useKerning}{logical.  Should kerning corrections be included in
    setting text and calculating string widths?  Defaults to \code{TRUE}.}
  \item{fillOddEven}{logical controlling the polygon fill mode:  see
    \code{\link{polygon}} for details.  Defaults to \code{FALSE}.}
  \item{compress}{logical.  Should PDF streams be generated with \I{Flate}
    compression?  Defaults to \code{TRUE}.}
  \item{timestamp}{logical.  If \code{FALSE}, omit the \samp{/CreationDate}
    and \samp{/ModDate} metadata fields.  Defaults to \code{TRUE}.}
  \item{producer}{logical.  If \code{FALSE}, omit the \samp{/Producer}
    metadata field.  Defaults to \code{TRUE}.}
  \item{author}{author string to embed as the \samp{/Author} field in the
    document metadata.  Defaults to \code{""}, omitting the field.}
}
\details{
  All arguments except \code{file} default to values given by
  \code{\link{pdf.options}()}.  The ultimate defaults are quoted in the
  arguments section.

  \code{pdf()} opens the file \code{file} and the PDF commands needed to
  plot any graphics requested are sent to that file.

  The \code{family} argument can be used to specify a PDF-specific
  font family as the initial/default font for the device.  If additional
  font families are to be used they should be included in the
  \code{fonts} argument.

  If a device-independent \R graphics font family is specified (e.g., via
  \code{par(family = )} in the graphics package), the PDF device makes use
  of the PostScript font mappings to convert the \R graphics font family
  to a PDF-specific font family description.  (See the
  documentation for \code{\link{pdfFonts}}.)

  This device does \emph{not} embed fonts in the PDF file, so it is only
  straightforward to use mappings to the font families that can be
  assumed to be available in any PDF viewer: \code{"Times"}
  (equivalently \code{"serif"}), \code{"Helvetica"} (equivalently
  \code{"sans"}) and \code{"Courier"} (equivalently \code{"mono"}).
  Other families may be specified, but it is the user's responsibility
  to ensure that these fonts are available on the system and third-party
  software (e.g., Ghostscript) may be required to embed the fonts so
  that the PDF can be included in other documents (e.g., LaTeX): see
  \code{\link{embedFonts}}.  The URW-based families described for
  in section \sQuote{Families}.can be used with viewers, platform dependently:
  \describe{
    \item{on Unix-alikes}{viewers set up to use URW fonts, which is
      usual with those based on \code{xpdf} or Ghostscript.}
    \item{on Windows}{viewers such as \I{GSView} which utilise URW fonts.}
  }
  Since \code{\link{embedFonts}} makes use of Ghostscript, it should be
  able to embed the URW-based families for use with other viewers.

  The PDF produced is fairly simple, with each page being represented as
  a single stream (by default compressed and possibly with references to
  raster images).  The \R graphics model does not distinguish graphics
  objects at the level of the driver interface.

  The \code{version} argument declares the version of PDF that gets
  produced.  The version must be at least 1.2 when compression is used,
  1.4 for semi-transparent output to be understood, and at least 1.3 if
  CID fonts are to be used: if any of these features are used the
  version number will be increased (with a warning).  (PDF 1.4 was first
  supported by Acrobat 5 in 2001; it is very unlikely not to be
  supported in a current viewer.)

  Line widths as controlled by \code{par(lwd = )} are in multiples of
  1/96 inch.  Multiples less than 1 are allowed.  \code{pch = "."} with
  \code{cex = 1} corresponds to a square of side 1/72 inch, which is
  also the \sQuote{pixel} size assumed for graphics parameters such as
  \code{"cra"}.

  The \code{paper} argument sets the \samp{/MediaBox} entry in the file,
  which defaults to \code{width} by \code{height}.  If it is set to
  something other than \code{"special"}, a device region of the
  specified size is (by default) centred on the rectangle given by the
  paper size: if either \code{width} or \code{height} is less
  than \code{0.1} or too large to give a total margin of 0.5 inch, it is
  reset to the corresponding paper dimension minus 0.5.  Thus if you
  want the default behaviour of \code{\link{postscript}} use
  \code{pdf(paper = "a4r", width = 0, height = 0)} to centre the device region
  on a landscape A4 page with 0.25 inch margins.

  When the background colour is fully transparent (as is the initial
  default value), the PDF produced does not paint the background.  Most
  PDF viewers will use a white canvas so the visual effect is if the
  background were white.  This will not be the case when printing onto
  coloured paper, though.
}

\section{File specifications}{
  Tilde expansion (see \code{\link{path.expand}}) is done on the
  \code{file} argument.  An input with a marked encoding is converted to
  the native encoding or an error is given.

  For use with \code{onefile = FALSE}, give a C integer format such as
  \code{"Rplot\%03d.pdf"} (the default in that case) which is expanded
  using the page number, so this uses files \file{Rplot001.pdf}, \dots,
  \file{Rplot999.pdf}, \file{Rplot1000.pdf},

  A single integer format matching the \link{regular expression}
  \code{"\%[#0 +=-]*[0-9.]*[diouxX]"} is allowed in \code{file}.  The
  character string should not otherwise contain a \code{\%}: if it is
  really necessary, use \code{\%\%} in the string for \code{\%} in the
  file path.

  For \code{pdf}, \code{file} can be \code{NULL} when no external file
  is created (effectively, no drawing occurs), but the device may still
  be queried (e.g., for the size of text by (base graphics)
  \code{\link{strwidth}} or (\pkg{grid})
  \code{\link[grid]{stringWidth}}).
}

\section{Families}{
  Font families are collections of fonts covering the five font faces,
  (conventionally plain, bold, italic, bold-italic and symbol) selected
  by the graphics parameter \code{\link{par}(font = )} or the grid
  parameter \code{\link{gpar}(fontface = )}.  Font families can be
  specified either as an initial/default font family for the device
  via the \code{family} argument or after the device is opened by
  the graphics parameter \code{\link{par}(family = )} or the grid
  parameter \code{\link{gpar}(fontfamily = )}.  Families which will be
  used in addition to the initial family must be specified in the
  \code{fonts} argument when the device is opened.

  Font families are declared via a call to \code{\link{pdfFonts}}
  or \code{\link{postscriptFonts}}.

  The argument \code{family} specifies the initial/default font family
  to be used.  In normal use it is one of \code{"AvantGarde"},
  \code{"Bookman"}, \code{"Courier"}, \code{"Helvetica"},
  \code{"Helvetica-Narrow"}, \code{"NewCenturySchoolbook"},
  \code{"Palatino"} or \code{"Times"}, and refers to the standard Adobe
  PostScript fonts families of those names which are included (or
  cloned) in all common PDF/PostScript renderers.

  Many PDF/PostScript renders (including those based on
  Ghostscript) use the URW equivalents of these fonts, which are
  \code{"URWGothic"}, \code{"URWBookman"}, \code{"NimbusMon"},
  \code{"NimbusSan"}, \code{"NimbusSanCond"}, \code{"CenturySch"},
  \code{"URWPalladio"} and \code{"NimbusRom"} respectively.  If your
  viewer is using URW fonts, you will obtain access to more characters
  and more appropriate metrics by using these names.  To make these
  easier to remember, \code{"URWHelvetica" == "NimbusSan"} and
  \code{"URWTimes" == "NimbusRom"} are also supported.  However, if the
  viewer is not using URW fonts (for example Adobe Acrobat Reader) it
  may substitute inappropriately or not render at all. (Consider using
  \code{\link{embedFonts}}.)

  As from \R{}\sspace{}4.4.0 there is support for URW 2.0 fonts in
  families \code{"URW2Helvetica"} (with \samp{Oblique} fonts),
  \code{"URW2HelveticaItalic"} (with \samp{Italic} fonts),
  \code{"URW2Times"} and \code{"NimbusMonoPS"}.  As recent versions of
  Ghostscript will render with (and embed) these fonts. these families
  should be used instead of \code{"URWHelvetica"}, \code{"URWTimes"},
  \code{"NimbusSan"}, \code{"NimbusRom"}, and \code{"NimbusMon"}
  

  Another type of family makes use of CID-keyed fonts for East Asian
  languages -- see \code{\link{pdfFonts}}.

  The \code{family} argument is normally a character string naming a
  font family, but family objects generated by \code{\link{Type1Font}}
  and \code{\link{CIDFont}} are also accepted.  For compatibility with
  earlier versions of \R, the initial family can also be specified as a
  vector of four or five \abbr{afm} files.

  Note that \R does not embed the font(s) used in the PostScript output:
  see \code{\link{embedFonts}} for a utility to help do so.

  Viewers and embedding applications frequently substitute fonts for
  those specified in the family, and the substitute will often have
  slightly different font metrics. \code{useKerning = TRUE} spaces the
  letters in the string using kerning corrections for the intended
  family: this may look uglier than \code{useKerning = FALSE}.
}

\section{Encodings}{
  Encodings describe which glyphs are used to display the character codes
  (in the range 0--255).  Most commonly \R uses \I{ISOLatin1} encoding, and
  the examples for \code{\link{text}} are in that encoding.  However,
  the encoding used on machines running \R may well be different, and by
  using the \code{encoding} argument the glyphs can be matched to
  encoding in use.  This suffices for European and Cyrillic languages,
  but not for East Asian languages.  For the latter, composite CID fonts are
  used.  These fonts are useful for other languages: for example they
  may contain Greek glyphs. (The rest of this section applies only when CID
  fonts are not used.)

  None of this will matter if only ASCII characters (codes 32--126) are
  used as all the encodings (except \code{"TeXtext"}) agree over that
  range.  Some encodings are supersets of \I{ISOLatin1}.  However, if
  accented and special characters do not come out as you expect, you may
  need to change the encoding.  Some other encodings are supplied with
  \R: \code{"ISOLatin2.enc"} (Central/Eastern Europe),
  \code{"ISOLatin7.enc"} (ISO 8859-13, \sQuote{Baltic Rim}),
  \code{"ISOLatin9.enc"} (ISO 8859-15, including Euro),
  \code{"Cyrillic.enc"} (ISO 8859-5), \code{"KOI8-R.enc"},
  \code{"KOI8-U.enc"}, and the Windows encodings \code{"WinAnsi.enc"}
  (also known as \code{"CP1252.enc"}, \code{"CP1250.enc"}
  (Central/Eastern Europe), \code{"CP1251.enc"} (Cyrillic),
  \code{"Greek.enc"} (ISO 8859-7), \code{"CP1253.enc"} (modern Greek)
  and \code{"CP1257.enc"} (\sQuote{Baltic Rim}).  Note that many glyphs
  in these encodings are not in the fonts corresponding to the standard
  families.  (The Adobe ones for all but Courier, Helvetica and Times
  cover little more than Latin-1, whereas the URW ones also cover
  Latin-2, Latin-7, Latin-9 and Cyrillic but no Greek.  The Adobe
  exceptions cover the Latin character sets, but not the Euro.)

  NB: support for encodings other than \code{"ISOLatin1.enc"} (and the
  Windows ones on Windows) depends on support by the platform's
  \code{libiconv} in a UTF-8 locale.

  If you specify the encoding, it is your responsibility to ensure that
  the PostScript font contains the glyphs used.  One issue here is the
  Euro symbol which is in several encodings (including \I{WinAnsi} and
  \I{ISOLatin9} encodings) but may well not be in the PostScript fonts.  (It
  is in the URW variants; it is not in the supplied Adobe Font Metric
  files so will not be centred correctly.)

  There is an exception.  Character 45 (\code{"-"}) is always set
  as minus (its value in Adobe \I{ISOLatin1}) even though it is hyphen in
  the other encodings.  Hyphen is available as character 173 (octal
  0255) in all the Latin encodings, Cyrillic and Greek.  (This can be
  entered as \code{"\u00ad"} in a UTF-8 locale.)  There are some
  discrepancies in accounts of glyphs 39 and 96: the supplied encodings
  (except CP1250 and CP1251) treat these as \sQuote{\I{quoteright}} and
  \sQuote{\I{quoteleft}} (rather than \sQuote{\I{quotesingle}}/\sQuote{acute}
  and \sQuote{grave} respectively), as they are in the Adobe
  documentation.
}

\section{Color models}{
  The default color model (\code{"srgb"}) is \abbr{sRGB}.  Model \code{"gray"}
  (or \code{"grey"}) maps \abbr{sRGB} colors to greyscale using perceived
  luminosity (biased towards green).  \code{"cmyk"} outputs in CMYK
  colorspace.  The simplest possible conversion from \abbr{sRGB} to CMYK is
  used
  (\url{https://en.wikipedia.org/wiki/CMYK_color_model#Mapping_RGB_to_CMYK}),
  and raster images are output in RGB.

  Also available for backwards compatibility is model \code{"rgb"} which
  uses uncalibrated RGB and corresponds to the model used with that name
  in \R prior to 2.13.0.  Some viewers may render some plots in that
  colorspace faster than in \abbr{sRGB}, and the plot files will be smaller.
}

\section{Conventions}{
  This section describes the implementation of the conventions for
  graphics devices set out in the \sQuote{R Internals} manual.

  \itemize{
    \item The default device size is 7 inches square.
    \item Font sizes are in big points.
    \item The default font family is Helvetica.
    \item Line widths are as a multiple of 1/96 inch, with a minimum
    of 0.01 enforced.
    \item Circles of any radius are allowed.  If \code{useDingbats =
      TRUE}, opaque circles of less than 10 big points radius are
    rendered using char 108 in the Dingbats font: all semi-transparent
    and larger circles using a \I{\enc{Bézier}{Bezier}} curve for each
    quadrant.
    \item Colours are by default specified as \abbr{sRGB}.
  }

  At very small line widths, the line type may be forced to solid.
}

\section{Printing}{
  Except on Windows it is possible to print directly from \code{pdf} by
  something like (this is appropriate for a CUPS printing system):
\preformatted{    pdf("|lp -o landscape", paper = "a4r")}
  This forces \code{onefile = TRUE}.
}
\note{
  If you have drawn any typeset glyphs (see \code{\link{glyphInfo}})
  then it is \emph{highly} recommended that you use
  \code{\link{embedGlyphs}} to embed the relevant fonts.
}
\note{
  If you see problems with PDF output, do remember that the problem is
  much more likely to be in your viewer than in \R.  Try another
  viewer if possible.  Symptoms for which the viewer has been at fault
  are apparent grids on image plots (turn off graphics anti-aliasing
  in your viewer if you can) and missing or incorrect glyphs in text
  (viewers silently doing font substitution).

  Unfortunately the default viewers on most Linux and macOS systems
  have these problems, and no obvious way to turn off graphics anti-aliasing.

  Acrobat Reader does not use the fonts specified but rather emulates
  them from multiple-master fonts.  This can be seen in imprecise
  centering of characters, for example the multiply and divide signs in
  Helvetica.  This can be circumvented by embedding fonts where
  possible.  Most other viewers substitute fonts, e.g.\sspace{}URW fonts
  for the standard Helvetica and Times fonts, and these too often have
  different font metrics from the true fonts.

  Acrobat Reader can be extended by \sQuote{font packs}, and these will
  be needed for the full use of encodings other than Latin-1 (although
  they may be offered for download as needed).

  \describe{
    \item{On some Unix-alike systems:}{
      If \code{useDingbats = TRUE},
      the default plotting character \code{pch = 1} was
  displayed in some PDF viewers incorrectly as a \code{"q"}
  character.  (These seem to be viewers based on the \samp{poppler} PDF
  rendering library).  This may be due to incorrect or incomplete mapping
  of font names to those used by the system.  Adding the following lines
  to \file{~/.fonts.conf} or \file{/etc/fonts/local.conf} may circumvent
  this problem, although this has largely been corrected on the affected
  systems.
\preformatted{<fontconfig>
<alias binding="same">
  <family>ZapfDingbats</family>
  <accept><family>Dingbats</family></accept>
</alias>
</fontconfig>
}
  Some further workarounds for problems with symbol fonts on
  viewers using \sQuote{\I{fontconfig}} are given in the \sQuote{Cairo Fonts}
  section of the help for \code{\link{X11}}.
 }
 \item{On Windows:}{
  The \I{TeXworks} PDF viewer was one of those which has been seen to fail to
  display Dingbats (used by e.g.\sspace{}\code{pch = 1}) correctly.
  Whereas on other platforms the problems seen were incorrect output, on
  Windows points were silently omitted: however recent versions seem to
  manage to display Dingbats.
 }
}%end{describe}

  There was a different font bug in the \command{pdf.js} viewer included
  in Firefox: that mapped Dingbats to the Symbol font and so displayed
  symbols such \code{pch = 1} as lambda.
}

\seealso{
  \code{\link{pdfFonts}}, \code{\link{pdf.options}},
  \code{\link{embedFonts}}, \code{\link{glyphInfo}},
  \code{\link{Devices}},
  \code{\link{postscript}}.

  \code{\link{cairo_pdf}} and (on macOS only) \code{\link{quartz}}
  for other devices that can produce PDF.

  More details of font families and encodings and especially handling
  text in a non-Latin-1 encoding and embedding fonts can be found in

  \bibshow{
  Paul Murrell and Brian Ripley (2006).
  \dQuote{Non-standard fonts in PostScript and PDF graphics.}
  \emph{R News}, \bold{6}(2), 41--47.
  \url{https://www.r-project.org/doc/Rnews/Rnews_2006-2.pdf}.}
}
\examples{
\donttest{
## Test function for encodings
TestChars <- function(encoding = "ISOLatin1", ...)
{
    pdf(encoding = encoding, ...)
    par(pty = "s")
    plot(c(-1,16), c(-1,16), type = "n", xlab = "", ylab = "",
         xaxs = "i", yaxs = "i")
         title(paste("Centred chars in encoding", encoding))
    grid(17, 17, lty = 1)
    for(i in c(32:255)) {
        x <- i \%\% 16
        y <- i \%/\% 16
        points(x, y, pch = i)
    }
    dev.off()
}
## there will be many warnings.
TestChars("ISOLatin2")
## this does not view properly in older viewers.
TestChars("ISOLatin2", family = "URWHelvetica")
## works well for viewing in gs-based viewers, and often in xpdf.
}}
\keyword{device}
