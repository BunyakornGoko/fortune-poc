// ===== CHINESE FORTUNE TELLER JAVASCRIPT =====

document.addEventListener("DOMContentLoaded", function () {
  // DOM Elements
  const drawFortuneBtn = document.getElementById("drawFortuneBtn")
  const drawAgainBtn = document.getElementById("drawAgainBtn")
  const closeResultBtn = document.getElementById("closeResultBtn")
  const fortuneResult = document.getElementById("fortuneResult")
  const loadingOverlay = document.getElementById("loadingOverlay")
  const fortuneSticks = document.getElementById("fortuneSticks")
  const chineseText = document.getElementById("chineseText")
  const thaiText = document.getElementById("thaiText")
  const prizeNumber = document.getElementById("prizeNumber")
  const luckyColor = document.getElementById("luckyColor")
  const luckyNumbers = document.getElementById("luckyNumbers")

  // Sound effects (optional - can be added later)
  const playSound = (type) => {
    // Placeholder for sound effects
    // You can add actual sound files here
    console.log(`Playing ${type} sound`)
  }

  // Stick selection animation
  const animateStickSelection = () => {
    const sticks = document.querySelectorAll(".stick")
    let selectedSticks = []
    let animationCount = 0
    const maxAnimations = 15 // Number of random selections before final selection

    return new Promise((resolve) => {
      const interval = setInterval(() => {
        // Reset all sticks
        sticks.forEach((stick) => {
          stick.classList.remove("selected", "highlighted")
        })

        // Randomly highlight sticks
        const randomSticks = Array.from(sticks)
          .sort(() => 0.5 - Math.random())
          .slice(0, Math.floor(Math.random() * 5) + 1)

        randomSticks.forEach((stick) => {
          stick.classList.add("highlighted")
        })

        animationCount++

        // Final selection
        if (animationCount >= maxAnimations) {
          clearInterval(interval)

          // Select final stick
          const finalStick = sticks[Math.floor(Math.random() * sticks.length)]
          sticks.forEach((stick) => stick.classList.remove("highlighted"))
          finalStick.classList.add("selected")

          // Add dramatic effect
          setTimeout(() => {
            finalStick.style.transform =
              "translateY(-30px) rotate(10deg) scale(1.2)"
            finalStick.style.boxShadow =
              "0 20px 40px rgba(245, 158, 11, 0.6), 0 0 30px #FCD34D"
            playSound("stickSelected")

            setTimeout(() => {
              resolve()
            }, 1000)
          }, 500)
        }
      }, 100)
    })
  }

  // Particle explosion effect
  const createParticleExplosion = (element) => {
    const colors = ["#DC2626", "#F59E0B", "#FCD34D", "#EF4444"]
    const particles = 20

    for (let i = 0; i < particles; i++) {
      const particle = document.createElement("div")
      particle.style.cssText = `
        position: fixed;
        width: 8px;
        height: 8px;
        background: ${colors[Math.floor(Math.random() * colors.length)]};
        border-radius: 50%;
        pointer-events: none;
        z-index: 1000;
        left: ${
          element.getBoundingClientRect().left + element.offsetWidth / 2
        }px;
        top: ${
          element.getBoundingClientRect().top + element.offsetHeight / 2
        }px;
      `

      document.body.appendChild(particle)

      // Animate particle
      const angle = (Math.PI * 2 * i) / particles
      const velocity = 3 + Math.random() * 5
      let posX = 0
      let posY = 0
      let opacity = 1

      const animateParticle = () => {
        posX += Math.cos(angle) * velocity
        posY += Math.sin(angle) * velocity
        opacity -= 0.02

        particle.style.transform = `translate(${posX}px, ${posY}px)`
        particle.style.opacity = opacity

        if (opacity > 0) {
          requestAnimationFrame(animateParticle)
        } else {
          document.body.removeChild(particle)
        }
      }

      requestAnimationFrame(animateParticle)
    }
  }

  // Text typewriter effect
  const typewriterEffect = (element, text, speed = 50) => {
    element.innerHTML = ""
    let i = 0

    return new Promise((resolve) => {
      const timer = setInterval(() => {
        if (i < text.length) {
          element.innerHTML += text.charAt(i)
          i++
        } else {
          clearInterval(timer)
          resolve()
        }
      }, speed)
    })
  }

  // Fortune drawing function
  const drawFortune = async () => {
    try {
      // Disable button and show loading
      drawFortuneBtn.disabled = true
      loadingOverlay.classList.remove("hidden")
      playSound("drawing")

      // Hide previous result (modal)
      fortuneResult.classList.add("hidden")

      // Clear previous results
      chineseText.innerHTML = ""
      thaiText.innerHTML = ""
      prizeNumber.textContent = ""
      luckyColor.textContent = ""
      luckyNumbers.textContent = ""

      // Animate stick selection
      await animateStickSelection()

      // Fetch fortune from server
      const response = await fetch("/fortune/draw", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document
            .querySelector('meta[name="csrf-token"]')
            ?.getAttribute("content")
        }
      })

      if (!response.ok) {
        throw new Error("Network response was not ok")
      }

      const data = await response.json()

      // Hide loading
      loadingOverlay.classList.add("hidden")

      // Create particle explosion effect
      createParticleExplosion(drawFortuneBtn)
      playSound("fortuneRevealed")

      // Show result in modal
      fortuneResult.classList.remove("hidden")
      document.body.style.overflow = "hidden"

      // Animate text reveal with typewriter effect
      await Promise.all([
        typewriterEffect(chineseText, data.chinese_fortune, 80),
        new Promise((resolve) => setTimeout(resolve, 500)) // Delay for Thai text
      ])

      await typewriterEffect(thaiText, data.thai_fortune, 60)

      // Show additional info with stagger animation
      prizeNumber.textContent = data.prize_number
      luckyColor.textContent = data.lucky_color
      luckyNumbers.textContent = data.lucky_numbers.join(", ")

      // Animate additional info items
      const infoItems = document.querySelectorAll(".info-item")
      infoItems.forEach((item, index) => {
        item.style.opacity = "0"
        item.style.transform = "translateX(-20px)"

        setTimeout(() => {
          item.style.transition = "all 0.5s ease"
          item.style.opacity = "1"
          item.style.transform = "translateX(0)"
        }, index * 200)
      })

      // Add success animation to result container
      const resultContainer = document.querySelector(".result-container")
      resultContainer.style.animation = "none"
      resultContainer.offsetHeight // Trigger reflow
      resultContainer.style.animation = "fadeInScale 0.8s ease-out"

      playSound("complete")
    } catch (error) {
      console.error("Error drawing fortune:", error)
      loadingOverlay.classList.add("hidden")

      // Show error message
      alert("เกิดข้อผิดพลาดในการเสี่ยงเซียมซี กรุณาลองใหม่อีกครั้ง")
    } finally {
      drawFortuneBtn.disabled = false
    }
  }

  // Reset function for drawing again
  const resetFortune = () => {
    // Reset stick animations
    const sticks = document.querySelectorAll(".stick")
    sticks.forEach((stick) => {
      stick.classList.remove("selected", "highlighted")
      stick.style.transform = ""
      stick.style.boxShadow = ""
    })

    // Hide result (modal)
    fortuneResult.classList.add("hidden")
    document.body.style.overflow = ""

    // Clear previous results
    chineseText.innerHTML = ""
    thaiText.innerHTML = ""
    prizeNumber.textContent = ""
    luckyColor.textContent = ""
    luckyNumbers.textContent = ""

    // Reset info items opacity and transform
    const infoItems = document.querySelectorAll(".info-item")
    infoItems.forEach((item) => {
      item.style.opacity = ""
      item.style.transform = ""
      item.style.transition = ""
    })

    // Reset animation delays for a fresh experience
    sticks.forEach((stick, index) => {
      stick.style.animationDelay = `${index * 0.1}s`
    })

    playSound("reset")
  }

  // Enhanced stick hover effects
  const enhanceStickInteractions = () => {
    const sticks = document.querySelectorAll(".stick")

    sticks.forEach((stick, index) => {
      // Set CSS custom property for animation delay
      stick.style.setProperty("--stick-index", index)

      // Add hover sound effect
      stick.addEventListener("mouseenter", () => {
        if (!stick.classList.contains("selected")) {
          playSound("stickHover")

          // Add subtle glow effect
          stick.style.transition = "all 0.3s ease"
          stick.style.filter = "brightness(1.2)"
        }
      })

      stick.addEventListener("mouseleave", () => {
        if (!stick.classList.contains("selected")) {
          stick.style.filter = ""
        }
      })

      // Add click interaction (optional direct selection)
      stick.addEventListener("click", () => {
        if (!drawFortuneBtn.disabled && !stick.classList.contains("selected")) {
          playSound("stickClick")

          // Add quick pulse animation
          stick.style.animation = "none"
          stick.offsetHeight // Trigger reflow
          stick.style.animation = "pulse 0.3s ease"
        }
      })
    })
  }

  // Initialize floating elements animation randomness
  const randomizeFloatingElements = () => {
    const symbols = document.querySelectorAll(".floating-symbol")
    symbols.forEach((symbol) => {
      const randomDelay = Math.random() * 20
      const randomDuration = 15 + Math.random() * 10
      symbol.style.animationDelay = `${randomDelay}s`
      symbol.style.animationDuration = `${randomDuration}s`
    })
  }

  // Add sparkle effect to buttons
  const addSparkleEffect = (element) => {
    element.addEventListener("mouseenter", () => {
      const sparkles = 5
      const rect = element.getBoundingClientRect()

      for (let i = 0; i < sparkles; i++) {
        const sparkle = document.createElement("div")
        sparkle.style.cssText = `
          position: fixed;
          width: 4px;
          height: 4px;
          background: #FCD34D;
          border-radius: 50%;
          pointer-events: none;
          z-index: 1000;
          left: ${rect.left + Math.random() * rect.width}px;
          top: ${rect.top + Math.random() * rect.height}px;
          animation: sparkle 0.8s ease-out forwards;
        `

        document.body.appendChild(sparkle)

        setTimeout(() => {
          if (sparkle.parentNode) {
            document.body.removeChild(sparkle)
          }
        }, 800)
      }
    })
  }

  // Add CSS for sparkle animation
  const addSparkleCSS = () => {
    const style = document.createElement("style")
    style.textContent = `
      @keyframes sparkle {
        0% {
          opacity: 1;
          transform: scale(0) rotate(0deg);
        }
        50% {
          opacity: 1;
          transform: scale(1) rotate(180deg);
        }
        100% {
          opacity: 0;
          transform: scale(0) rotate(360deg);
        }
      }
    `
    document.head.appendChild(style)
  }

  // Background ambient animation
  const createAmbientEffect = () => {
    setInterval(() => {
      const container = document.querySelector(".fortune-container")
      if (container && Math.random() < 0.3) {
        // 30% chance every interval
        const rect = container.getBoundingClientRect()
        const x = Math.random() * rect.width
        const y = Math.random() * rect.height

        const glow = document.createElement("div")
        glow.style.cssText = `
          position: fixed;
          left: ${rect.left + x}px;
          top: ${rect.top + y}px;
          width: 20px;
          height: 20px;
          background: radial-gradient(circle, rgba(245, 158, 11, 0.3), transparent);
          border-radius: 50%;
          pointer-events: none;
          z-index: -1;
          animation: ambientGlow 3s ease-out forwards;
        `

        document.body.appendChild(glow)

        setTimeout(() => {
          if (glow.parentNode) {
            document.body.removeChild(glow)
          }
        }, 3000)
      }
    }, 2000)
  }

  // Add ambient glow CSS
  const addAmbientCSS = () => {
    const style = document.createElement("style")
    style.textContent = `
      @keyframes ambientGlow {
        0% {
          opacity: 0;
          transform: scale(0);
        }
        50% {
          opacity: 1;
          transform: scale(1);
        }
        100% {
          opacity: 0;
          transform: scale(1.5);
        }
      }
    `
    document.head.appendChild(style)
  }

  // Event Listeners
  drawFortuneBtn.addEventListener("click", drawFortune)
  drawAgainBtn.addEventListener("click", resetFortune)
  closeResultBtn.addEventListener("click", resetFortune)

  // Close modal when clicking outside paper
  fortuneResult.addEventListener("click", (e) => {
    if (e.target === fortuneResult) {
      resetFortune()
    }
  })

  // Close with Escape
  document.addEventListener("keydown", (e) => {
    if (e.key === "Escape" && !fortuneResult.classList.contains("hidden")) {
      resetFortune()
    }
  })

  // Initialize enhancements
  enhanceStickInteractions()
  randomizeFloatingElements()
  addSparkleEffect(drawFortuneBtn)
  addSparkleEffect(drawAgainBtn)
  addSparkleCSS()
  addAmbientCSS()
  createAmbientEffect()

  // Add welcome animation
  setTimeout(() => {
    playSound("welcome")
  }, 1000)

  console.log("🏮 Chinese Fortune Teller initialized successfully! 🏮")
})
