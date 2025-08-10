FROM python:3.12-slim
ENV TZ=America/New_York

ARG WG_USER
ARG WG_PASS
ARG WG_PORT=53255

RUN mkdir /code
WORKDIR /code

COPY requirements.txt .

RUN apt-get update -y && \
    apt-get install -y gcc git && \
    pip install -r requirements.txt && \
	ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY ./waterguru_flask.py .

RUN sed -i "s/WG_USER/${WG_USER}/" /code/waterguru_flask.py && \
	sed -i "s/WG_PASS/${WG_PASS}/" /code/waterguru_flask.py && \
	sed -i "s/WG_PORT/${WG_PORT}/" /code/waterguru_flask.py

EXPOSE ${WG_PORT}
CMD [ "python3.12", "/code/waterguru_flask.py" ]
