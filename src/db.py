from sqlalchemy import create_engine

def get_engine():
    return create_engine(
        "postgresql+psycopg2://shreyanshpathak:postgres@localhost/churn_early_warning"
    )
