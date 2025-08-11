db <- dbConnect(RSQLite::SQLite(), "www/birdbuff.db")

onStop(function() {
  dbDisconnect(db)
})