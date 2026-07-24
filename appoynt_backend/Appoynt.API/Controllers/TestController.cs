using Appoynt.API.Controllers;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Appoynt.API.Controllers
{
    /// <summary>
    /// Temporary controller used to verify that the API is running.
    /// </summary>
    [Route("api/[controller]")]
    [ApiController]
    [Tags("Test")]
    public class TestController : ControllerBase
    {
        /// <summary>
        /// Gets the API status.
        /// </summary>
        /// <returns>A simple message indicating the API is working.</returns>
        /// <response code="200">API is working correctly</response>
        [HttpGet]
        [ProducesResponseType(typeof(string), StatusCodes.Status200OK)]
        public IActionResult Get()
        {
            return Ok("API Working");
        }

        /// <summary>
        /// Tests the POST endpoint.
        /// </summary>
        /// <param name="message">A test message</param>
        /// <returns>The received message</returns>
        /// <response code="200">Request processed successfully</response>
        [HttpPost]
        [ProducesResponseType(typeof(TestMessage), StatusCodes.Status200OK)]
        public IActionResult Post([FromBody] TestMessage message)
        {
            if (message == null || string.IsNullOrEmpty(message.Message))
                return BadRequest("Message is required");

            return Ok(new { receivedMessage = message.Message, timestamp = DateTime.UtcNow });
        }

        /// <summary>
        /// Gets a message by ID.
        /// </summary>
        /// <param name="id">The message ID</param>
        /// <returns>The message with the specified ID</returns>
        /// <response code="200">Message found</response>
        /// <response code="404">Message not found</response>
        [HttpGet("{id}")]
        [ProducesResponseType(typeof(TestMessage), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public IActionResult GetById(int id)
        {
            if (id <= 0)
                return NotFound("Invalid ID");

            return Ok(new { id, message = $"This is message {id}", timestamp = DateTime.UtcNow });
        }
    }

    /// <summary>
    /// Represents a test message.
    /// </summary>
    public class TestMessage
    {
        /// <summary>
        /// Gets or sets the message content.
        /// </summary>
        public string Message { get; set; } = string.Empty;
    }
}