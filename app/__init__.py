from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_bcrypt import Bcrypt
from flask_jwt_extended import JWTManager
from .config import Config

db = SQLAlchemy()
bcrypt = Bcrypt()
jwt = JWTManager()


def create_app(config_class=Config):
    app = Flask(__name__)
    app.config.from_object(config_class)

    db.init_app(app)
    bcrypt.init_app(app)
    jwt.init_app(app)

    from .routes.auth import auth_bp
    from .routes.plans import plans_bp
    from .routes.professionals import professionals_bp
    from .routes.todos import todos_bp

    app.register_blueprint(auth_bp, url_prefix="/api/auth")
    app.register_blueprint(plans_bp, url_prefix="/api/plans")
    app.register_blueprint(professionals_bp, url_prefix="/api/professionals")
    app.register_blueprint(todos_bp, url_prefix="/api/todos")

    @app.get("/health")
    def health():
        return {"status": "ok"}, 200

    return app