from __future__ import annotations

from flask import Blueprint, render_template
from flask.views import View

bp = Blueprint("game", __name__)


class SnakeGameView(View):
    init_every_request = False

    def dispatch_request(self) -> str:
        return render_template("index.html")


bp.add_url_rule("/", view_func=SnakeGameView.as_view("home"))