# Superstore project

This project processes the Superstore.xls dataset using the modern data engineering stack learned in Module 4.
The pipeline performs ETL (Extract, Transform, Load) operations, builds a data mart in ClickHouse, and visualizes insights through Metabase dashboards.

---

## 🛠️ Tech Stack & Architecture

### Tech Stack

* [![Python 3.12](https://img.shields.io/badge/Python-3.12-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
* [![Pandas](https://img.shields.io/badge/Pandas-150458?style=for-the-badge&logo=pandas&logoColor=white)](https://pandas.pydata.org/)
* [![ClickHouse](https://img.shields.io/badge/ClickHouse-FFCC01?style=for-the-badge&logo=clickhouse&logoColor=black)](https://clickhouse.com/)
* [![Airflow](https://img.shields.io/badge/Apache%20Airflow-017CEE?style=for-the-badge&logo=apacheairflow&logoColor=white)](https://airflow.apache.org/)
* [![Metabase](https://img.shields.io/badge/Metabase-509488?style=for-the-badge&logo=metabase&logoColor=white)](https://www.metabase.com/)
* [![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
* [![Docker Compose](https://img.shields.io/badge/Docker%20Compose-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://docs.docker.com/compose/)
* [![dbt](https://img.shields.io/badge/dbt-FF694B?style=for-the-badge&logo=dbt&logoColor=white)](https://www.getdbt.com/)

### Architecture
![Architecture](./docs/architecture.drawio.svg)

--- 
## ⚙️ Getting Started 

### Prerequisites
- Docker and Docker Compose installed 
- Git 
- A `.env` file (if you use one) 

### Installation & Setup 

1. **Clone the repository:** 
   ```bash
   git clone [https://github.com/jinjik19/DE-101.git](https://github.com/jinjik19/DE-101.git) 
   cd DE-101/Module4/superstore_project
   ``
   
2. **Set up environment variables:** 
   *Create a `.env` file in the root directory by copying the example file.* 
   ```bash
   cp .env.example .env 
   ``
   *Modify the `.env` file with your specific settings (if any).* 
   
3. **Build and run the services:** 
   ```bash 
   docker-compose up --build -d 
   ``

--- 
