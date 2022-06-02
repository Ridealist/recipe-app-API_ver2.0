# The Dockerfile is used to build our image, which contains a mini Linux Operating System with all the 
# dependencies needed to run our project.

FROM python:3.9-alpine3.13
LABEL maintainer="github.com/Ridealist"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    # actual image에서 사용하지 않을 파일은 build process에서 삭제하는 습관!(임시파일 등)
    # TO make Docker image as lightweight as possible
    rm -rf /tmp && \
    # DON'T RUN your App using THE ROOT USER!!
    # App이 get compromised 된다면, 해커는 해당 Docker container에 대한 full access 권한을 갖는 위험
    adduser \
        # --disabled-password
        -D \
        # --no-create-home
        -H \
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user

# #9 41.04 Create new user, or add USER to GROUP
# #9 41.04
# #9 41.04        -h DIR          Home directory
# #9 41.04        -g GECOS        GECOS field
# #9 41.04        -s SHELL        Login shell
# #9 41.04        -G GRP          Group
# #9 41.04        -S              Create a system user
# #9 41.04        -D              Don't assign a password
# #9 41.04        -H              Don't create home directory
# #9 41.04        -u UID          User id
# #9 41.04        -k SKEL         Skeleton directory (/etc/skel)
# ------
# executor failed running [/bin/sh -c python -m venv /py &&     /py/bin/pip install --upgrade pip &&     /py/bin/pip install -r /tmp/requirements.txt &&     rm -rf /tmp &&     adduser         --disable-password         --no-create-home         django-user]: exit code: 1