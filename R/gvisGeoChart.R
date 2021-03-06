### File R/gvisGeoChart.R
### Part of the R package googleVis
### Copyright 2010 - 2014 Markus Gesmann, Diego de Castillo

### It is made available under the terms of the GNU General Public
### License, version 2, or at your option, any later version,
### incorporated herein by reference.
###
### This program is distributed in the hope that it will be
### useful, but WITHOUT ANY WARRANTY; without even the implied
### warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
### PURPOSE.  See the GNU General Public License for more
### details.
###
### You should have received a copy of the GNU General Public
### License along with this program; if not, write to the Free
### Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
### MA 02110-1301, USA

#' Google Geo Chart with R
#' \Sexpr{googleChartName <- "geochart"}
#' \Sexpr{gvisChartName <- "gvisGeoChart"}
#' 
#' The gvisGeoChart function reads a data.frame and creates text output
#' referring to the Google Visualisation API, which can be included into a web
#' page, or as a stand-alone page.
#' 
#' A geo chart is a map of a country, a continent, or a region with two modes:
#' The region mode colorizes whole regions, such as countries, provinces, or
#' states. The marker mode marks designated regions using bubbles that are
#' scaled according to a value that you specify.
#' 
#' A geo chart is rendered within the browser using SVG or VML. Note that the
#' map is not scrollable or draggable.
#' 
#' 
#' @param data a \code{data.frame}. The data has to have at least one column
#' with location name (\code{locationvar}), value to be mapped to location. The
#' format of the data varies depending on which display mode that you use:
#' Regions or Markers.
#' @param locationvar column name of \code{data} with the geo locations to be
#' analysed. The locations can be provide in two formats: \describe{
#' \item{Format 1}{'latitude:longitude'. See the example below.} \item{Format
#' 2}{Address, country name, region name locations, or US metropolitan area
#' codes, see
#' \url{http://code.google.com/apis/adwords/docs/developer/adwords_api_us_metros.html}.
#' This format works with the \code{dataMode} option set to either 'markers' or
#' 'regions'. The following formats are accepted: A specific address (for
#' example, "1600 Pennsylvania Ave"). A country name as a string (for example,
#' "England"), or an uppercase ISO-3166 code or its English text equivalent
#' (for example, "GB" or "United Kingdom").  An uppercase ISO-3166-2 region
#' code name or its English text equivalent (for example, "US-NJ" or "New
#' Jersey").  } }
#' @param colorvar column name of \code{data} with the optional numeric column
#' used to assign a color to this marker, based on the scale specified in the
#' \code{colorAxis.colors} property. If this column is not present, all markers
#' will be the same color. If the column is present, null values are not
#' allowed. Values are scaled relative to each other, or absolutely to values
#' specified in the \code{colorAxis.values} property.
#' @param sizevar only used for \code{displayMode='markers'}. Column name of
#' \code{data} with the optional numeric column used to assign the marker size,
#' relative to the other marker sizes. If this column is not present, the value
#' from the previous column will be used (or default `size, if no color column
#' is provided as well). If the column is present, null valuesare not allowed.
#' @param hovervar column name of \code{data} with the additional string text
#' displayed when the user hovers over this region.
#' @param options list of configuration options, see:
#' 
#' % START DYNAMIC CONTENT
#' 
#' \Sexpr[results=rd]{gsub("CHARTNAME", 
#' googleChartName,
#' readLines(file.path(".", "inst",  "mansections", 
#' "GoogleChartToolsURLConfigOptions.txt")))}
#' 
#'  \Sexpr[results=rd]{paste(readLines(file.path(".", "inst", 
#'  "mansections", "gvisOptions.txt")))}
#'   
#' @param chartid character. If missing (default) a random chart id will be 
#' generated based on chart type and \code{\link{tempfile}}
#' 
#' @return \Sexpr[results=rd]{paste(gvisChartName)} returns list 
#' of \code{\link{class}}
#'  \Sexpr[results=rd]{paste(readLines(file.path(".", "inst", 
#'  "mansections", "gvisOutputStructure.txt")))}
#'   
#' @references Google Chart Tools API: 
#' \Sexpr[results=rd]{gsub("CHARTNAME", 
#' googleChartName, 
#' readLines(file.path(".", "inst",  "mansections", 
#' "GoogleChartToolsURL.txt")))}
#' 
#' % END DYNAMIC CONTENT
#' 
#' @author Markus Gesmann \email{markus.gesmann@@gmail.com}, 
#' Diego de Castillo \email{decastillo@@gmail.com}
#' 
#' @seealso 
#' See also \code{\link{print.gvis}}, \code{\link{plot.gvis}} 
#' for printing and plotting methods.
#' 
#' @export
#' 
#' @keywords iplot
#' 
#' @examples
#' 
#' ## Please note that by default the googleVis plot command
#' ## will open a browser window and requires Internet
#' ## connection to display the visualisation.
#' 
#' ## Regions examples
#' ## The regions style fills entire regions (typically countries) with
#' ## colors corresponding to the values that you assign
#' 
#' G1a <- gvisGeoChart(Exports, locationvar='Country', colorvar='Profit') 
#' 
#' plot(G1a)
#' 
#' ## Change projection
#' G1b <- gvisGeoChart(Exports, locationvar='Country', colorvar='Profit',
#'                    options=list(projection="kavrayskiy-vii")) 
#' 
#' plot(G1b)
#' 
#' ## Plot only Europe
#' G2 <- gvisGeoChart(Exports, "Country", "Profit",
#'                    options=list(region="150"))
#' 
#' plot(G2)
#' 
#' 
#' ## Example showing US data by state 
#' require(datasets)
#' 
#' states <- data.frame(state.name, state.x77)
#' G3 <- gvisGeoChart(states, "state.name", "Illiteracy",
#'                  options=list(region="US", displayMode="regions", 
#'                               resolution="provinces",
#'    	 width=600, height=400))
#' plot(G3)
#' 
#' ## Markers Example
#' ## A marker style map renders bubble-shaped markers at specified
#' ## locations with the color and size that you specify.
#' 
#' G4 <- gvisGeoChart(CityPopularity, locationvar='City', colorvar='Popularity',
#'                       options=list(region='US', height=350, 
#'                                    displayMode='markers',
#' 				   colorAxis="{values:[200,400,600,800],
#'                                    colors:[\'red', \'pink\', \'orange',\'green']}")
#'                       ) 
#' plot(G4)
#' 
#' G5 <- gvisGeoChart(Andrew, "LatLong", colorvar='Speed_kt',
#'                    options=list(region="US"))
#' plot(G5)
#' 
#' 
#' G6 <- gvisGeoChart(Andrew, "LatLong", sizevar='Speed_kt',
#'                    colorvar="Pressure_mb", options=list(region="US"))
#' plot(G6)
#' 
#' ## Create lat:long values and plot a map of Oceania
#' ## Set background colour to light-blue
#' 
#' require(stats)
#' data(quakes)
#' head(quakes)
#' quakes$latlong<-paste(quakes$lat, quakes$long, sep=":")
#' 
#' G7 <- gvisGeoChart(quakes, "latlong", "depth", "mag",
#'                    options=list(displayMode="Markers", region="009",
#'                    colorAxis="{colors:['red', 'grey']}",
#'                    backgroundColor="lightblue"))
#' 
#' plot(G7)
#' 
#' \dontrun{
#' # Plot S&P countries' credit rating sourced from Wikipedia
#' # Use the hovervar to show the rating
#' library(XML)
#' url <- "http://en.wikipedia.org/wiki/List_of_countries_by_credit_rating"
#' x <- readHTMLTable(readLines(url), which=3)
#' levels(x$Rating) <- substring(levels(x$Rating), 4, 
#'                               nchar(levels(x$Rating)))
#' x$Ranking <- x$Rating
#' levels(x$Ranking) <- nlevels(x$Rating):1
#' x$Ranking <- as.character(x$Ranking)
#' x$Rating <- paste(x$Country, x$Rating, sep=": ")
#' #### Create a geo chart
#' G8 <- gvisGeoChart(x, "Country", "Ranking", hovervar="Rating",
#'                 options=list(gvis.editor="S&P", 
#'                              colorAxis="{colors:['#91BFDB', '#FC8D59']}"))
#' plot(G8)
#' 
#' 
#' ## Plot world wide earth quakes of the last 30 days with magnitude >= 4.0 
#' library(XML)
#' ## Get earthquake data of the last 30 days
#' url <- "http://ds.iris.edu/sm2/eventlist/"
#' eq <- readHTMLTable(readLines(url),
#'                     colClasses=c("factor", rep("numeric", 4), "factor"))$evTable
#'                     names(eq) <- c("DATE", "LAT", "LON", "MAG",
#'                                    "DEPTH", "LOCATION_NAME", "IRIS_ID")
#' ##Format location data
#' eq$loc=paste(eq$LAT, eq$LON, sep=":")                   
#' G9 <- gvisGeoChart(eq, "loc", "DEPTH", "MAG",
#'                    options=list(displayMode="Markers", 
#'                    colorAxis="{colors:['purple', 'red', 'orange', 'grey']}",
#'                    backgroundColor="lightblue"), chartid="EQ")
#' plot(G9)
#' }
#' 
gvisGeoChart <- function(data, locationvar="", ## numvar="",
                         colorvar="", sizevar="",
                         hovervar="",
                         options=list(), chartid){

  my.type <- "GeoChart"
  dataName <- deparse(substitute(data))

  my.options <- list(gvis=modifyList(list(width = 556, height=347),options), 
                     dataName=dataName,
                     data=list(locationvar=locationvar,
                               hovervar=hovervar,  
                               ## numvar=numvar,
                       colorvar=colorvar,
                       sizevar=sizevar,
                       
                       allowed=c("number", "string")
                       )
                     )
  
  checked.data <- gvisCheckGeoChartData(data, my.options)

  if(any("numeric" %in% lapply(checked.data[,1], class))){
    my.options <- modifyList(list(gvis=list()), my.options)
  }
  output <- gvisChart(type=my.type, checked.data=checked.data, options=my.options, chartid=chartid)
  
  return(output)
}


gvisCheckGeoChartData <- function(data, options){

  data.structure <- list(
        	     locationvar = list(mode="required",FUN=check.location),
        	     hovervar    = list(mode="optional",FUN=check.char),
        	     ## numvar      = list(mode="optional",FUN=check.num),
                     colorvar      = list(mode="optional",FUN=check.num),
        	     sizevar    = list(mode="optional",FUN=check.num))
	
  x <- gvisCheckData(data=data,options=options,data.structure=data.structure)

  if (sum(nchar(gsub("[[:digit:].-]+:[[:digit:].-]+", "", x[[1]]))) == 0){
  	# split first index and delete this one
  	latlong <- as.data.frame(do.call("rbind",strsplit(as.character(x[[1]]),':')))
  	x[[1]] <- NULL
	varNames <- names(x)
  	x$Latitude <- as.numeric(as.character(latlong$V1))
  	x$Longitude <- as.numeric(as.character(latlong$V2))
    	x <- x[c("Latitude","Longitude",varNames)]
  }

  return(data.frame(x))
}

## gvisCheckGeoMapData <- function(data, options){
## 
##   data.structure <- list(
##                          locationvar = list(mode="required",FUN=check.location),
##                          numvar      = list(mode="optional",FUN=check.num),
##                          sizevar     = list(mode="optional",FUN=check.num)
##                          )
## 	
##   x <- gvisCheckData(data=data,options=options,data.structure=data.structure)
##   
##   return(data.frame(x))
## }
