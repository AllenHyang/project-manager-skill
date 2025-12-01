from setuptools import setup, find_packages

setup(
    name="pm",
    version="4.0.0",
    description="Project management tool with automatic logging",
    author="Allen",
    author_email="allen@example.com",
    license="MIT",
    packages=find_packages(),
    install_requires=[
        "pyyaml",
    ],
    entry_points={
        "console_scripts": [
            "pm=pm.cli.main:main",
        ],
    },
    python_requires=">=3.7",
)
