from setuptools import setup

package_name = "talkerlistener"

setup(
    name=package_name,
    version="0.0.0",
    packages=[package_name],
    data_files=[
        ("share/ament_index/resource_index/packages", ["resource/" + package_name]),
        ("share/" + package_name, ["package.xml"]),
    ],
    install_requires=["setuptools"],
    zip_safe=True,
    maintainer="vscode",
    maintainer_email="jakkaj@gmail.com",
    description="TODO: Package description",
    license="TODO: License declaration",
    tests_require=["pytest"],
    entry_points={
        "console_scripts": [
            "talker = talkerlistener.publisher_member_function:main",
            "listener = talkerlistener.subscriber_member_function:main",
        ],
    },
)
