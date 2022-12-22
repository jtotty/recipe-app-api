# Alpine is a lightweight Linux distro to run python in
FROM python:3.9-alpine3.13
LABEL maintainer="jtotty"

# Stop python from buffering the output
ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false

# 1. Create a python virtual environment.
# 2. Upgrade pip (python package manager).
# 3. Install postrgresql client.
# 4. Install virtual dependency package.
# 5. Use pip to install our packages specified.
# 6. Remove the tmp directory (no longer needed).
# 7. Remove tmp build deps (no longer needed).
# 8. Avoid using root user. Create new user that doesn't have the full privileges.
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cahce --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# Update PATH env variable
ENV PATH="/py/bin:$PATH"

# Switch to the custom user we made
USER django-user