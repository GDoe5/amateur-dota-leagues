db_connect <- function(os, local = TRUE) {
  if (os == "windows") {
    DBI::dbConnect(
      RPostgres::Postgres(),
      host = if (local) "localhost",
      port = 5432,
      dbname = "tournament",
      user = keyring::key_get("db_user"),
      password = keyring::key_get("db_password")
    )
  } else {
    DBI::dbConnect(
      RPostgres::Postgres(),
      host = if (local) "localhost",
      port = 5432,
      dbname = "tournament",
      user = Sys.getenv("DB_USER"),
      password = Sys.getenv("DB_PASSWORD")
    )
  }
}


db_reset <- function(os) {
  con <- db_connect(os)
  on.exit(DBI::dbDisconnect(con))

  DBI::dbExecute(con, "DROP SCHEMA IF EXISTS db CASCADE")
  DBI::dbExecute(con, "CREATE SCHEMA IF NOT EXISTS db")
  DBI::dbExecute(con, "GRANT ALL ON SCHEMA db TO db_user")

  sql_files <- list.files("sql", full.names = TRUE)

  purrr::walk(sql_files, function(file) {
    file_contents <- readLines(file)
    sql <- paste(file_contents, collapse = "\n")
    DBI::dbExecute(con, sql)
    message(file_contents[1])
  })
}
