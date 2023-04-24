# Introductory Shiny
2023-04-11

## Introduction

This training course in an introduction to Shiny for data analysts working in health, care, and housing. 

The training is designed for people who are already fairly comfortable working in R, but without any prior Shiny experience. While the expectations are fairly low - you absolutely don’t need to be an R
expert to successfully complete this training - you should have some previous experience using R. As the course has a tidyverse flavour, trainees should ensure that they are familiar with core tidyverse
functions (dplyr and ggplot especially).

If you're new to R, we would suggest enrolling on our [Introductory R and Rmarkdown](https://learn.nes.nhs.scot/62249) course before undertaking this Shiny training.

## What this training will cover

This course will cover the basics of building a simple dashboard in Shiny. You can [see a live preview of the finished dashboard](https://l8865y-brendan-clarke.shinyapps.io/KIND_intro_shiny_final_app/). This will include:

+ an introduction to Shiny and reactive programming
+ basic user interface design
+ translating R scripts into Shiny
+ managing health and care data in Shiny, including using open data
+ storytelling and communication with Shiny

## Course format

The training is delivered as a series of four live Teams session using [Posit
Cloud](https://rstudio.cloud/). Trainees should plan to attend all four sessions in a course. Course details will be released on the [KIND Learning Network Teams channel](https://teams.microsoft.com/l/team/19%3aQZ7-PbFVcziG2piHLt1_ifey3I2cwFL0yBuTSS8vVao1%40thread.tacv2/conversations?groupId=106d08f3-9026-40e2-b3c7-87cd87304d58&tenantId=10efe0bd-a030-4bca-809c-b5e6745e499a) as they become available.

If you’ve never used Posit Cloud before, it’s a [SaaS](https://en.wikipedia.org/wiki/Software_as_a_service) version of Rstudio in the browser. Note that because it’s a web service, it requires you to upload your data to their servers, which generally makes it unsuitable for production work in health and care owing to information governance concerns. That said, it’s an excellent venue for training, because it solves many of the difficulties regarding R versions, permissions, etc that are a feature of using R on the desktop. It’s also very easy to transfer projects from Posit Cloud to an installed version of R, so don’t worry that what you learn here will be tied to the cloud forever.

## Requirements

As Posit Cloud is a web service, you don’t need a particularly up-to-date computer to completed this training. As long as you have a reliable internet connection, and are capable of making a video call with Microsoft Teams (for the face-to-face part of the training), then you should be fine. The demonstration has been tested on Windows 10, Windows 11, and Ubuntu Linux 21.04 without platform-specific difficulties.

It is extremely helpful, although not essential, to have **a multi-monitor setup**. That way you can run the demonstration in one screen, and the Teams call on the other.

You should also, as discussed above, be fairly comfortable with R basics before you enrol on this training. Do please get in touch with [Brendan Clarke](mailto:%20brendan.clarke2@nhs.scot?subject=Intermediate%20R%20training) to discuss if you are at all unsure.

## Joining instructions

You’ll need to do a little bit of preparation before the first training session, which should take about 15 minutes to complete. Please make sure you have completed this before the start of the first session so that we can make a prompt start. If you’re new to Posit Cloud, please follow the step-by-step instructions below. If you’ve worked with Posit Cloud before, you can just sign-in to your account at Posit Cloud, and create a new project from the GitHub Repository at <https://github.com/bclarke-nes/KIND-shiny-intro>.

### Step-by-step instructions

1.  Go to <https://rstudio.cloud/>
2.  If you have an account, you can log in as normal. Otherwise, please
    create a new account by selecting Get started for free, following
    the steps, and then signing-in
3.  Once you’ve signed-in to Posit Cloud, add a new project by clicking
    New Project \>\> New Project from a Git repository. When prompted,
    enter the following URL:
    <https://github.com/bclarke-nes/KIND-shiny-intro>

Note that some corporate VPNs may prevent Posit Cloud from working properly, so we would recommend disconnecting from your VPN if at all possible.

## Aims and objectives

### Aims

- To introduce reactive programming using Shiny 
- To provide a social learning space to support learners as they develop their skills
- To show how Shiny can be used to visualise real-world health and social care data

### Objectives

By the end of these session, the user should:

- Have an understanding of how to build simple Shiny apps
- To understand how R and Shiny differ, and how R scripts might be translated to Shiny apps
- To see how Shiny might be used in their current work
- Have participated in social learning during the training sessions, reviewing the code of other trainees and assisting with trouble-shooting
- Have confidence in reading third-party Shiny code, including awareness of suitable places to seek help
