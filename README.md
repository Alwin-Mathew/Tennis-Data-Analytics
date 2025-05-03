# Tennis-Data-Analysis
This is a repository containing codes and  queries regarding Sports radar API data extraction and data analytics on Tennis data

**Problem Statement: **
The SportRadar Event Explorer project aims to develop a comprehensive solution 
for managing, visualizing, and analyzing sports competition data extracted from the 
Sportradar API. The application will parse JSON data, store structured information in a 
relational database, and provide intuitive insights into tournaments, competition 
hierarchies, and event details. This project is designed to assist sports enthusiasts, 
analysts, and organizations in understanding competition structures and trends while 
exploring detailed event-specific information interactively. 

**Data Extraction** 
● Parse and extract data from Sportradar JSON responses.(using API) 
● Transform nested JSON structures into a flat relational schema for analysis. 
**Data Storage:**  
● Create a SQL database with well-designed schema (e.g., defining appropriate 
data types and primary keys).

**Build a Streamlit Application: **
● Connect the Streamlit app with the SQL database for real-time query execution. 
● Display analysis results in the form of tables, charts, or dashboards within the 
app.User Interface: Interactive dashboards with filters for competition types, 
levels, and categories. 

**Tables Used Are:**
1. Categories Table
2. Competitions Table
3. Complexes Table
4. Venues Table
5. Competitor_Rankings Table
6. Competitors Table

**Data Analysis Using SQL Questions :**
1) List all competitions along with their category name 
2) Count the number of competitions in each category 
3) Find all competitions of type 'doubles' 
4) Get competitions that belong to a specific category (e.g., ITF Men) 
5) Identify parent competitions and their sub-competitions 
6) Analyze the distribution of competition types by category 
7) List all competitions with no parent (top-level competitions)
8) List all venues along with their associated complex name
9) Count the number of venues in each complex
10) Get details of venues in a specific country (e.g., Chile)
11) Identify all venues and their timezones
12) Find complexes that have more than one venue
13) List venues grouped by country
14) Find all venues for a specific complex (e.g., Nacional)
15) Get all competitors with their rank and points.
16) Find competitors ranked in the top 5
17) List competitors with no rank movement (stable rank)
18) Get the total points of competitors from a specific country (e.g., Croatia)
19) Count the number of competitors per country
20) Find competitors with the highest points in the current week 


