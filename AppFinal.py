#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import streamlit as st
import pandas as pd
from sqlalchemy import create_engine
import altair as alt

# DB connection
DATABASE_URI = "mysql+mysqlconnector://root:root#123@127.0.0.1:3306/tennis_data"
engine = create_engine(DATABASE_URI)

def execute_query(query, params=None):
    with engine.connect() as conn:
        return pd.read_sql(query, conn, params=params)

# Sidebar navigation
st.sidebar.title("Tennis Data Explorer")
page = st.sidebar.selectbox("Go to", [
    "Home Page", "Search Competitors", "Competitor Details", 
    "Country Analysis", "Leaderboards"])

# 1. Homepage Dashboard
if page == "Home Page":
    st.title("\U0001F3C6 Tennis Analytics Dashboard")

    col1, col2, col3, col4 = st.columns(4)

    with col1:
        total_competitors = execute_query("SELECT COUNT(*) as total FROM Competitors")['total'].iloc[0]
        st.metric("Competitors", total_competitors)

    with col2:
        countries = execute_query("SELECT COUNT(DISTINCT country) as num_countries FROM Competitors")['num_countries'].iloc[0]
        st.metric("Countries Represented", countries)

    with col3:
        max_points = execute_query("SELECT MAX(points) as max_points FROM Competitor_Rankings")['max_points'].iloc[0]
        st.metric("Highest Points", max_points)

    with col4:
        total_venues = execute_query("SELECT COUNT(*) as total_venues FROM Venues")['total_venues'].iloc[0]
        st.metric("Venues", total_venues)

    st.subheader("Top 3 Most Active Categories")
    most_active_categories = execute_query("""
            SELECT v.category_name AS Category,
                   COUNT(competition_id) as Competitions
            FROM categories v
            JOIN competitions c
            ON v.category_id = c.category_id
            GROUP BY category_name
            ORDER BY COUNT(competition_id) DESC
            LIMIT 3
    """)
    st.table(most_active_categories)

    st.subheader("Top 10 Players by Points")
    top_percent = execute_query("""
            SELECT c.name AS Competitor, 
                   cr.Rank, 
                   cr.Points
            FROM Competitors c
            JOIN Competitor_Rankings cr 
            ON c.competitor_id = cr.competitor_id
            ORDER BY cr.Points DESC
            LImit 10
    """)
    st.dataframe(top_percent)

    st.subheader("Player Count by Category")
    category_df = execute_query("""
        SELECT cat.category_name AS Category, COUNT(*) AS Players
        FROM Competitions comp
        JOIN Categories cat ON comp.category_id = cat.category_id
        JOIN Competitor_Rankings cr ON cr.competitor_id IS NOT NULL
        GROUP BY cat.category_name
    """)
    chart = alt.Chart(category_df).mark_bar().encode(
        x='Category',
        y='Players',
        tooltip=['Category', 'Players']
    ).properties(width=700)
    st.altair_chart(chart, use_container_width=True)

# 2. Search and Filter Competitors
elif page == "Search Competitors":
    st.title("\U0001F50D Search Competitors")

    name = st.text_input("Search by name")
    rank_range = st.slider("Rank Range", 1, 1000, (1, 100))
    country = st.text_input("Filter by Country")
    min_points = st.number_input("Minimum Points", value=0)

    query = """
    SELECT c.Name, c.Country, cr.Rank, cr.Points
    FROM Competitors c
    JOIN Competitor_Rankings cr ON c.competitor_id = cr.competitor_id
    WHERE c.name LIKE %s AND cr.rank BETWEEN %s AND %s AND cr.points >= %s
    ORDER BY cr.Points DESC,cr.Rank ASC
    """
    params = (f"%{name}%", rank_range[0], rank_range[1], min_points)

    if country:
        query += " AND c.Country = %s"
        params += (country,)

    df = execute_query(query, params)
    st.dataframe(df)

# 3. Competitor Details Viewer
elif page == "Competitor Details":
    st.title("\U0001F9D1 Competitor Details Viewer")

    competitors = execute_query("SELECT name FROM Competitors ORDER BY name")
    selected_name = st.selectbox("Select a competitor", competitors['name'].tolist())

    query = """
    SELECT c.Name, c.Country, cr.Rank, cr.Movement, cr.Points, cr.Competitions_played AS Competitions
    FROM Competitors c
    JOIN Competitor_Rankings cr ON c.competitor_id = cr.competitor_id
    WHERE c.name = %s
    """
    df = execute_query(query, (selected_name,))
    st.table(df)

# 4. Country-Wise Analysis
elif page == "Country Analysis":
    st.title("\U0001F30D Country-Wise Competitor Analysis")

    query = """
    SELECT c.Country, 
           COUNT(*) AS Competitors,
           AVG(cr.points) AS AvgPoints
    FROM Competitors c
    JOIN Competitor_Rankings cr 
    ON c.competitor_id = cr.competitor_id
    GROUP BY c.Country
    ORDER BY Competitors DESC
    """
    df = execute_query(query)
    st.dataframe(df)

# 5. Leaderboards
elif page == "Leaderboards":
    st.title("\U0001F3C5 Leaderboards")

    st.subheader("Top Ranked Competitors")
    top_ranked = execute_query("""
        SELECT c.Name, c.Country, cr.Rank
        FROM Competitor_Rankings cr
        JOIN Competitors c ON cr.competitor_id = c.competitor_id
        ORDER BY cr.rank ASC
        LIMIT 10
    """)
    st.table(top_ranked)

    st.subheader("Highest Point Scorers")
    top_points = execute_query("""
        SELECT c.Name, c.Country, cr.Points
        FROM Competitor_Rankings cr
        JOIN Competitors c ON cr.competitor_id = c.competitor_id
        ORDER BY cr.points DESC
        LIMIT 10
    """)
    st.dataframe(top_points)

    st.subheader("Categories with Highest Matches")
    category_counts = execute_query("""
        SELECT cat.category_name AS Category, 
               COUNT(*) AS Matches
        FROM Competitions comp
        JOIN Categories cat ON comp.category_id = cat.category_id
        GROUP BY cat.category_name
        ORDER BY Matches DESC
    """)
    st.dataframe(category_counts)
    
    st.subheader("Countries with Highest No.of Competitors")
    competitors = execute_query("""
        SELECT c.Country, 
               COUNT(c.competitor_id) AS Competitors
        FROM Competitors c
        GROUP BY c.Country
        ORDER BY COUNT(c.competitor_id) DESC
    """)
    st.dataframe(competitors)

