import os
from sqlalchemy.orm import sessionmaker
from sqlalchemy import func
from property_management_db import City, Annonce, Equipment, engine

# Initialize the session
Session = sessionmaker(bind=engine)
session = Session()

# --------------------
# Example Query 1: Retrieve All Annonces for a Specific City
# --------------------
def get_annonces_for_city(city_name):
    city = session.query(City).filter_by(name=city_name).first()
    if city:
        annonces = session.query(Annonce).filter_by(city_id=city.id).all()
        print(f"\nAnnonces for {city_name}:")
        for annonce in annonces:
            print(f"Title: {annonce.title}, Price: {annonce.price}, Rooms: {annonce.nb_rooms}, Baths: {annonce.nb_baths}")
    else:
        print(f"No city found with the name: {city_name}")

# --------------------
# Example Query 2: Filter Annonces by Number of Rooms and Bathrooms
# --------------------
def filter_annonces_by_rooms_and_baths(min_rooms, min_baths):
    filtered_annonces = session.query(Annonce).filter(
        Annonce.nb_rooms >= min_rooms,
        Annonce.nb_baths >= min_baths
    ).all()

    print(f"\nFiltered Annonces (Min Rooms: {min_rooms}, Min Baths: {min_baths}):")
    for annonce in filtered_annonces:
        print(f"Title: {annonce.title}, Price: {annonce.price}")

# --------------------
# Example Query 3: Filter Annonces by Price Range
# --------------------
def filter_annonces_by_price(min_price, max_price):
    annonces = session.query(Annonce).filter(
        Annonce.price >= min_price,
        Annonce.price <= max_price
    ).all()

    print(f"\nAnnonces in Price Range ({min_price} - {max_price}):")
    for annonce in annonces:
        print(f"Title: {annonce.title}, Price: {annonce.price}")

# --------------------
# Example Query 4: Get Annonces with a Specific Equipment
# --------------------
def get_annonces_with_equipment(equipment_name):
    equipment = session.query(Equipment).filter_by(name=equipment_name).first()
    if equipment:
        annonces = equipment.annonces
        print(f"\nAnnonces with Equipment '{equipment_name}':")
        for annonce in annonces:
            print(f"Title: {annonce.title}, Price: {annonce.price}")
    else:
        print(f"No equipment found with the name: {equipment_name}")

# --------------------
# Example Query 5: Count Number of Annonces by City
# --------------------
def count_annonces_by_city():
    city_counts = session.query(City.name, func.count(Annonce.id)).join(Annonce).group_by(City.name).all()
    print("\nNumber of Annonces by City:")
    for city_name, count in city_counts:
        print(f"{city_name}: {count} annonces")

# --------------------
# Example Query 6: Find Annonces by Surface Area
# --------------------
def filter_annonces_by_surface(min_surface, max_surface):
    annonces = session.query(Annonce).filter(
        Annonce.surface_area >= min_surface,
        Annonce.surface_area <= max_surface
    ).all()

    print(f"\nAnnonces with Surface Area in Range ({min_surface} - {max_surface} m²):")
    for annonce in annonces:
        print(f"Title: {annonce.title}, Surface Area: {annonce.surface_area} m²")

# --------------------
# Example Query 7: Retrieve Annonces by Publication Date
# --------------------
def get_annonces_by_date(start_date, end_date):
    annonces = session.query(Annonce).filter(
        Annonce.datetime >= start_date,
        Annonce.datetime <= end_date
    ).all()

    print(f"\nAnnonces Published Between {start_date} and {end_date}:")
    for annonce in annonces:
        print(f"Title: {annonce.title}, Date: {annonce.datetime}")

# --------------------
# Main Function to Run All Queries
# --------------------
if __name__ == "__main__":
    # Test each query function

    # Query 1: Get all annonces for a specific city
    get_annonces_for_city("Casablanca")

    # Query 2: Filter annonces by number of rooms and bathrooms
    filter_annonces_by_rooms_and_baths(min_rooms=2, min_baths=1)

    # Query 3: Filter annonces by price range
    filter_annonces_by_price(min_price=500000, max_price=2000000)

    # Query 4: Get annonces with a specific equipment
    get_annonces_with_equipment("Balcony")

    # Query 5: Count number of annonces by city
    count_annonces_by_city()

    # Query 6: Find annonces by surface area
    filter_annonces_by_surface(min_surface=50, max_surface=150)

    # Query 7: Retrieve annonces by publication date
    from datetime import datetime
    get_annonces_by_date(
        start_date=datetime(2024, 1, 1),
        end_date=datetime(2024, 12, 31)
    )

    # Close the session
    session.close()
