"""JS/CSS Webpack bundles for {{cookiecutter.project_name}}."""

from invenio_assets.webpack import WebpackThemeBundle

theme = WebpackThemeBundle(
    __name__,
    "assets",
    default="semantic-ui",
    themes={
        "semantic-ui": dict(
            entry={
                # Add your webpack entrypoints
            },
            # used to override react translations.
            # the file points to site/{{cookiecutter.project_shortname}} during build time
            aliases={"@overriden_translations": "../translations"},
        ),
    },
)
