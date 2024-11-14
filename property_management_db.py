import os
import sys
import pandas as pd
from datetime import datetime
from sqlalchemy import create_engine, Column, Integer, String, Float, ForeignKey, DateTime, Table
from sqlalchemy.orm import relationship, sessionmaker
from sqlalchemy.ext.declarative import declarative_base

# Set up the paths for module imports
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

# Base class for all models
Base = declarative_base()

# Database connection using a properly formatted URL
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://postgres:post@localhost:5432/postgres")
engine = create_engine(DATABASE_URL)

# City Table
class City(Base):
    __tablename__ = 'city'
    id = Column(Integer, primary_key=True)
    name = Column(String, nullable=False)

    # Relationship with Annonce (One-to-Many)
    annonces = relationship("Annonce", back_populates="city")

# Many-to-Many Association Table between Annonce and Equipment
annonce_equipment = Table(
    'annonce_equipment', Base.metadata,
    Column('annonce_id', Integer, ForeignKey('annonce.id'), primary_key=True),
    Column('equipment_id', Integer, ForeignKey('equipment.id'), primary_key=True)
)

# Equipment Table
class Equipment(Base):
    __tablename__ = 'equipment'
    id = Column(Integer, primary_key=True)
    name = Column(String, nullable=False)

    # Relationship with Annonce through the association table (Many-to-Many)
    annonces = relationship("Annonce", secondary=annonce_equipment, back_populates="equipments")

# Annonce Table
class Annonce(Base):
    __tablename__ = 'annonce'
    id = Column(Integer, primary_key=True)
    title = Column(String, nullable=False)
    price = Column(Float, nullable=True)  # Use Float for numeric price values
    datetime = Column(DateTime, nullable=False)
    nb_rooms = Column(Integer, nullable=True)
    nb_baths = Column(Integer, nullable=True)
    surface_area = Column(Float, nullable=True)
    link = Column(String, nullable=True)
    
    # Foreign Key to City Table
    city_id = Column(Integer, ForeignKey('city.id'), nullable=False)
    city = relationship("City", back_populates="annonces")

    # Relationship with Equipment through the association table (Many-to-Many)
    equipments = relationship("Equipment", secondary=annonce_equipment, back_populates="annonces")

# Create all tables
def create_tables():
    Base.metadata.create_all(engine)
    print("Tables created successfully.")

# Insert data into the database
def insert_data():
    # Create the database engine and session
    Session = sessionmaker(bind=engine)
    session = Session()

    # Load the cleaned CSV data
    df = pd.read_csv('cleaned_avito_listing.csv')

    # Insert Cities into the database
    for city_name in df['city'].unique():
        existing_city = session.query(City).filter_by(name=city_name).first()
        if not existing_city:
            city = City(name=city_name)
            session.add(city)
    session.commit()

    # Insert Advertisements (Annonce) into the database
    for _, row in df.iterrows():
        city = session.query(City).filter_by(name=row['city']).first()
        if city:
            advertisement = Annonce(
                title=row['title'],
                price=row['price'],
                datetime=datetime.strptime(row['datetime'], '%Y-%m-%d %H:%M:%S'),
                nb_rooms=row['nb_rooms'],
                nb_baths=row['nb_baths'],
                surface_area=row['surface_area'],
                link=row['link'],
                city_id=city.id
            )
            session.add(advertisement)
    session.commit()

    # Insert Equipment into the database
    for equipment_name in df['equipement'].unique():
        existing_equipment = session.query(Equipment).filter_by(name=equipment_name).first()
        if not existing_equipment:
            equipment = Equipment(name=equipment_name)
            session.add(equipment)
    session.commit()

    # Insert relationships between Advertisements (Annonce) and Equipment
    for _, row in df.iterrows():
        advertisement = session.query(Annonce).filter_by(title=row['title']).first()
        equipment = session.query(Equipment).filter_by(name=row['equipement']).first()

        if advertisement and equipment:
            if equipment not in advertisement.equipments:  # Avoid duplicates
                advertisement.equipments.append(equipment)

    session.commit()
    session.close()

    print("Data inserted successfully.")

# Main execution
if __name__ == "__main__":
    create_tables()
    insert_data()
