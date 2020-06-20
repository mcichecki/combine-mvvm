# Combine + UIKit + MVVM

![Build & Tests](https://github.com/mcichecki/Combine-MVVM/workflows/Unit%20Tests/badge.svg)

### Sample project with Combine, UIKit and MVVM architecture

This simple app consists of two screens and includes basic concepts that are common usecases for using reactive programming.

First screen showcases offline validation of text fields (login screen as an example).

Second screen presents fetching data from public and [free API](https://rapidapi.com).

### Set up

To run the app clone this repository and provide apiKey in [`PlayersService`](https://github.com/mcichecki/Combine-MVVM/blob/79fe946d372ae7dd3969ab4f5654a30b74271ed9/CombineDemo/API/Service/PlayersService.swift#L22) class.

### Github Actions

Simple workflow responsible for running unit tests can be found in [workflow-test.yml](https://github.com/mcichecki/Combine-MVVM/blob/master/.github/workflows/workflow-test.yml) file.
