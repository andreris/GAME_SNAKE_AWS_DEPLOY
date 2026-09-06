from __future__ import annotations

from flask import Flask, render_template


def create_app(test_config: dict[str, object] | None = None) -> Flask:
    app = Flask(__name__)

    if test_config is not None:
        app.config.update(test_config)

    from snake_game.views import bp as game_bp

    app.register_blueprint(game_bp)
    register_error_handlers(app)
    return app


def register_error_handlers(app: Flask) -> None:
    @app.errorhandler(404)
    def page_not_found(error: object) -> tuple[str, int]:
        return render_template("404.html"), 404