
universalInit <- function(class_name, name, exclude = NULL, ...) {
  obj <- new(class_name)
  slt <- getSlots(class_name)
  arg <- list(...)
  if (!is.null(exclude)) arg <- arg[!(names(arg) %in% exclude)]
  obj@name <- name
  if (length(arg) != 0) {
    if (any(names(arg) == 'name')) stop('Duplicate parameter name')
    if (is.null(names(arg)) || any(names(arg) == '') ||
       anyDuplicated(names(arg)) != 0) stop('Wrong arguments name')
    if (any(sapply(arg, is.null))) stop('There is NULL argument')
    # Add aditional argument
    for(w in names(arg)) {
      ww <- arg[[w]]
      # List argument
      if (slt[w] == 'list') {
        slot(obj, w) <- ww
        # data.frame argument
      } else if (slt[w] == 'data.frame') {
        if (is.data.frame(ww)) {
          # Check: There is no additional column
          if (any(!(colnames(ww) %in% colnames(slot(obj, w))))) {
            stop(paste('Wrong argument "', w, '", undefined  slot: "', 
               paste(colnames(ww)[!(colnames(ww) %in% colnames(slot(obj, w)))], 
                 collapse = '", "'), '"\n', sep = ''))
          }
          slot(obj, w) <- slot(obj, w)[0,, drop = FALSE]
          if (nrow(ww) != 0) {
            nn <- 1:nrow(ww)
            slot(obj, w)[nn, ] <- NA
            for(i in names(ww)) {
              if (is.factor(slot(obj, w)[, i, drop = FALSE]) || is.factor(ww[, i])) {
                slot(obj, w)[nn, i] <- as.character(ww[, i])
              } else {
                slot(obj, w)[nn, i] <- ww[, i]
              }
            }
          }
        } else if (is.list(ww)) {
         gg <- sapply(ww, length)
          slot(obj, w) <- slot(obj, w)[0,, drop = FALSE]
          # Check: Equal length
          if (any(gg[1] != gg)) stop('Wrong argument ', w)
          # Check: All column has correct name
          if (is.null(names(ww)) || any(names(ww) == '') ||
             anyDuplicated(names(ww)) != 0) stop('Wrong argument ', w)
          # Check: There is no additional column
          if (any(!(names(ww) %in% colnames(slot(obj, w))))) stop('Wrong argument ', w)
          if (gg[1] != 0) {
             nn <- 1:gg[1]
             slot(obj, w)[nn, ] <- NA
             for(i in names(ww)) {
              slot(obj, w)[nn, i] <- ww[[i]]
            }
          }
        } else if (any(colnames(slot(obj, w)) == w) && length(ww) == 1) { 
        # for use start = 2000 rather than start = list(start = 2000)
             slot(obj, w)[1, ] <- NA
             slot(obj, w)[1, w] <- ww
        } else stop('Wrong argument ', w)
      # Other argument
      } else if (slt[w] == 'factor') {
        slot(obj, w) <- slot(obj, w)[0]
        if (length(ww) != 0) slot(obj, w)[seq(along = ww)] <- ww
      } else if (slt[w] == 'character') {
        slot(obj, w) <- as.character(ww)
      } else {
        slot(obj, w) <- ww
      } 
    }
  }
  obj
}

#universalInit('technology')
#print(newTechnology('technology', 'd3', description = 'jk', cap2act = 4, 
#  units = data.frame(capacity = 'MV', fixom = 'j', stringsAsFactors = FALSE)))

setGeneric("newTechnology", function(name, ...) standardGeneric("newTechnology"))
#' Create new technology object
#' 
#' @name newTechnology
#' 
setMethod('newTechnology', signature(name = 'character'), function(name, ...) 
  universalInit('technology', name, ...))

setGeneric("newCommodity", function(name, ...) standardGeneric("newCommodity"))
#' Create new commodity object
#' 
#' @name newCommodity
#' 
setMethod('newCommodity', signature(name = 'character'), function(name, ...) 
  universalInit('commodity', name, ...))

setGeneric("newDemand", function(name, ...) standardGeneric("newDemand"))
#' Create new demand object
#' 
#' @name newDemand
#' 
setMethod('newDemand', signature(name = 'character'), function(name, ...) 
  universalInit('demand', name, ...))

setGeneric("newSupply", function(name, ...) standardGeneric("newSupply"))
#' Create new supply object
#' 
#' @name newSupply
#' 
setMethod('newSupply', signature(name = 'character'), function(name, ...) 
  universalInit('supply', name, ...))

setGeneric("newExport", function(name, ...) standardGeneric("newExport"))
#' Create new export object
#' 
#' @name newExport
#' 
setMethod('newExport', signature(name = 'character'), function(name, ...) 
  universalInit('export', name, ...))

setGeneric("newImport", function(name, ...) standardGeneric("newImport"))
#' Create new import object
#' 
#' @name newImport
#' 
setMethod('newImport', signature(name = 'character'), function(name, ...) 
  universalInit('import', name, ...))

#setGeneric("newConstrain", function(name, ...) standardGeneric("newConstrain"))
#setMethod('newConstrain', signature(name = 'character'), function(name, ...) 
#  universalInit('constrain', name, ...))

setGeneric("newModel", function(name, ...) standardGeneric("newModel"))
#' Create new model object
#' 
#' @name newModel
#' 
setMethod('newModel', signature(name = 'character'), function(name, ...) {
    mdl <- universalInit('model', name, exclude = 'repository', ...)
    if (any(names(list(...))== 'repository'))  {
      mdl <- add(mdl, list(...)$repository)
    }
    mdl
  })

setGeneric("newRepository", function(name, ...) standardGeneric("newRepository"))
#' Create new repository object
#' 
#' @name newRepository
#' 
setMethod('newRepository', signature(name = 'character'), function(name, ...) 
  universalInit('repository', name, ...))

setGeneric("newModel", function(name, ...) standardGeneric("newModel"))
#' Create new model object
#' 
#' @name newModel
#' 
setMethod('newModel', signature(name = 'character'), function(name, ...) {
    mdl <- universalInit('model', name, exclude = 'repository', ...)
    if (any(names(list(...))== 'repository'))  {
      mdl <- add(mdl, list(...)$repository)
    }
    mdl
  })
