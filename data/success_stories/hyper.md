---
title: Sensor Analytics and Automation Platform for Sustainable Agriculture
logo: success-stories/hyper.png
card_logo: success-stories/white/hyper.svg
background: /success-stories/hyper-bg.jpg
theme: green
synopsis: "Hyper Uses OCaml to Build an IoT System for High-Performing Farms."
url: https://hyper.systems/
priority: 3
---

Hyper.ag provides a scalable sensor analytics and automation infrastructure for indoor and vertical farming. With their product, farmers continuously optimise the crop quality and reduce operational costs by getting access to actionable growth insights and climate control profiles without a dedicated engineering team.

## Challenge

Since the inception of the company, Hyper has had very unique product requirements to support deployments that manage thousands of low-power network devices and compute real-time metrics across a distributed server infrastructure:

1. Reliable implementation – customers expect the system to work without failures, as any interruptions to the service may have a direct impact on their business operations.
2. Controlled resource usage – deploying software on devices with constrained resources, where low memory profile and computation efficiency are important to support more advanced capabilities.
3. Offline-first deployments – the architecture of the distributed analytics and automation system requires precise state replication to support offline deployments for customers with farms in remote locations. It’s critical that this software operates reliably without any external services.
4. Developer productivity – most importantly, Hyper is a startup and needs to continuously iterate on product features with fast time-to-market and maintain a high degree of confidence in their work.

## Solution

While not being commonly regarded as a language or platform for IoT and embedded programming, OCaml has helped satisfy Hyper’s requirements in a way that’s unique to the strongly-typed functional paradigm, as it offers strong abstraction boundaries with declarative interfaces and numerous opportunities for optimisation.

Hyper leverages OCaml to design a product that is both extremely adaptable and offers a high degree of safety. While iterating their system design, they were able to rewrite several critical components numerous times with remarkable speed and without compromising reliability.

## Results

OCaml’s type system proved to be an excellent tool to express invariants and characteristics of every sensor and actuators that belongs to their IoT platform. This allows them to perform code generation for devices with constrained resources to achieve maximum performance, low network overhead and a high degree of flexibility when making changes to the system.

In addition to the robust language and a growing ecosystem of high-quality libraries, Hyper deeply values the commitment to backwards compatibility and long-term support promised by OCaml on their journey to build a lasting and impactful product.
