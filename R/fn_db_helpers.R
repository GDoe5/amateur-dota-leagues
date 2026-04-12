db_connect <- function(os, local = TRUE) {
  if (os == "windows") {
    pool::dbPool(
      RPostgres::Postgres(),
      host = if (local) "localhost",
      port = 5432,
      dbname = "tournament",
      user = keyring::key_get("db_user"),
      password = keyring::key_get("db_password")
    )
  } else {
    pool::dbPool(
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
  pool <- db_connect(os)
  on.exit(pool::poolClose(pool))

  DBI::dbExecute(pool, "DROP SCHEMA IF EXISTS db CASCADE")
  DBI::dbExecute(pool, "CREATE SCHEMA IF NOT EXISTS db")
  DBI::dbExecute(pool, "GRANT ALL ON SCHEMA db TO db_user")

  sql_files <- list.files("sql", full.names = TRUE)

  purrr::walk(sql_files, function(file) {
    file_contents <- readLines(file)
    sql <- paste(file_contents, collapse = "\n")
    DBI::dbExecute(pool, sql)
    message(file_contents[1])
  })
}
