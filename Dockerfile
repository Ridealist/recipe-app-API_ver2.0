FROM python:3.9-alpine3.13
LABEL maintainer="github.com/Ridealist"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    # actual image에서 사용하지 않을 파일은 build process에서 삭제하는 습관!(임시파일 등)
    # TO make Docker image as lightweight as possible
    rm -rf /tmp && \
    # DON'T RUN your App using THE ROOT USER!!
    # App이 get compromised 된다면, 해커는 해당 Docker container에 대한 full access 권한을 갖는 위험
    adduser \
        --disable-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user