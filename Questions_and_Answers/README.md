## Introduction
The dataset is a FIFA football dataset. Link to download the dataset https://drive.google.com/file/d/18fVQus1QXwiLSYd-r8kkXviz_WDOnxrE/view?usp=share_link


The dataset was cleaned using @Promise Chinonso Data cleaning Documentation Process. The Link to her medium article on the documentation process https://medium.com/microsoft-power-bi/data-cleaning-inspecting-and-wrangling-the-fifa-21-data-20cad3195595

## Data Modelling 
The dataset was a single table and the resulting model was 8 tables star scheme with a 1 to 1 relationship.
The Resulting Model Tables
- <strong>Profile</strong>: Holds players demographics and acts as the fact table
- <strong>Dim_Contract</strong>: Holds data on players contract, length of contract and contract type
- <strong>Dim_Rating</strong>: Holds data on players ratings, overall best rating and potential rating
- <strong>Dim_Mental_Abily</strong>: Holds data on players mental abilities
- <strong>Dim_Physical_Ability</strong>: Holds data on players physical abilities
- <strong>Dim_Technical_Ability</strong>: Holds data on players technical abilities
- <strong>Dim_Stats</strong>: Holds data on players other abilities
- <strong>Dim_GoalKeeping_Ability</strong>: Holds data on players goals keeping abilities

## Data Model
![model](https://user-images.githubusercontent.com/69252875/230791695-29805584-cc9f-4c4c-810e-24ae965c5f06.png)

## Data Tranfer Process
The database FIFA DB was created in MSSQL and the model was uploaded to the database using SSIS 

