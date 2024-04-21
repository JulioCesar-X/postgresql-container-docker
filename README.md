# Environment Setup:

- The environment consists of a Docker container running PostgreSQL.
- Docker Compose is used to manage the container.
- The database is persisted in a Docker volume to ensure data persists even when the container is restarted or replaced.

## How to Use:

- Make sure you have Docker and Docker Compose installed on your machine.

- Clone this repository to your local environment:
<code>git clone https://github.com/JulioCesar-X/postgresql-container-docker.git</code>

- Navigate to the cloned directory:
<code>cd repository-name</code>

- Run the docker-compose up command to start the PostgreSQL container:
<code>docker-compose up -d</code>

- Wait until the container is up and ready to accept connections.

- Connect to the database using a database management tool like DBeaver:
- Host: localhost
- Port: 5432
- Database Name: postgres_db (or the name specified in the POSTGRES_DATABASE environment variable)
- Username: root (or the name specified in the POSTGRES_USER environment variable)
- Password: root (or the password specified in the POSTGRES_PASSWORD environment variable)

- After successfully connecting, you can execute SQL queries, create new tables, insert data, and more in the PostgreSQL database.

### Notes:

- Ensure that the required ports (such as port 5432 for PostgreSQL) are not being used by other services on your machine.

- All database data is stored locally in the data/ directory, which is mounted as a Docker volume. This means that data will persist even after the container is shut down or restarted.

- The init_db.sql file can be used to initialize the database with tables, sample data, or any other desired configuration. This file is automatically executed when the PostgreSQL container is started for the first time.

- Make sure to review and customize the docker-compose.yml file as needed to meet the specific requirements of your project.

- This environment is primarily intended for local development and testing. For production environments, it is recommended to set up a separate PostgreSQL environment using security and scalability best practices.

# Contributions:

Contributions are welcome! If you encounter any issues or have suggestions for improvements, feel free to open an issue or send a pull request to this repository.